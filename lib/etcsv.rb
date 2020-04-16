require "etcsv/version"

module Etcsv
  class Error < StandardError; end

  require 'csv'

  class EtsyProducts

    def initialize (username)
      @username = username
    end

    def self.set_etsy_credentials (api_key, api_secret)
      Etsy.protocol = 'https'
      Etsy.api_key = api_key
      Etsy.api_secret = api_secret
    end

    def user
      return @user ||= Etsy.user(@username)
    end

    def shop
      return @shop ||= self.user.shop
    end

    def brand
      return @brand ||= self.shop.name
    end

    def export_catalog(csv_path)
      listings = Etsy::Listing.find_all_by_shop_id(self.shop.id, :limit => 1000)

      fb_catalog = [ ]
      listings.each do |listing| #removing extra fields
        fb_catalog << listing.result.slice("listing_id", "title", "description", "price", "quantity", "url")
      end

      fb_catalog.each do |item| # remove utm tags from listing url
        item["url"] = item["url"].split("?")[0]
      end

      fb_fields = {"brand" => self.brand, "condition" => "new", "availability" => "in stock"} #fb fields
      fb_catalog.each { |item| item.merge!(fb_fields) } #adding fb fields

      fb_catalog.each do |item| #getting primary image and additional images links
        images = Etsy::Image.find_all_by_listing_id(item["listing_id"])
        primary_image = ""
        album = []
        images.each do |img|
          if img.result["rank"] == 1
            primary_image = img.result["url_fullxfull"]
          else
            album << img.result["url_fullxfull"]
          end
        end
        item.merge!("image_link" => primary_image, "additional_image_link" => album.join(","))
        item["listing_id"] = item["listing_id"].to_s.prepend("etcsv-")
        # add prefix to the item["listing_id"]
      end

      CSV.open(csv_path, 'w') do |csv|
        csv << ['id', 'title', 'description', 'price', 'inventory', 'link', 'brand', 'condition', 'availability', 'image_link', 'additional_image_link']
        fb_catalog.each { |item| csv << item.values }
      end

    end

  end

end
