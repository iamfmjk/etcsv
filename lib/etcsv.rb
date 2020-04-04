require "etcsv/version"

module Etcsv
  class Error < StandardError; end

  require 'csv'
  require 'byebug'

  class EtsyProducts
    attr_accessor :user, :brand, :shop

    def initialize (username)
      @username = username
    end

    def self.set_etsy_credentials (api_key, api_secret)
      Etsy.protocol = 'https'
      Etsy.api_key = api_key
      Etsy.api_secret = api_secret
    end

    def export_catalog
      @user = Etsy.user(@username)
      puts @user.inspect
      @shop = @user.shop
      @listings = Etsy::Listing.find_all_by_shop_id(@shop.id, :limit => 1000)
      @brand = @shop.name

      fb_catalog = [ ]
      @listings.each do |listing| #removing extra fields
        fb_catalog << listing.result.slice("listing_id", "title", "description", "price", "quantity", "url")
      end

      fb_catalog.each do |item| # remove utm tags from listing url
        item["url"] = item["url"].split("?")[0]
        item["listing_id"] = item["listing_id"].to_s.prepend("etcsv-")
        # add prefix to the item["listing_id"]
      end

      fb_fields = {"brand" => brand, "condition" => "new", "availability" => "in stock"} #fb fields
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
      end

      time=Time.now.strftime("%Y%m%d-%H%M%S%L")

      CSV.open("#{brand}-#{time}.csv", 'w') do |csv|
        csv << ['id', 'title', 'description', 'price', 'inventory', 'link', 'brand', 'condition', 'availability', 'image_link', 'additional_image_link']
        fb_catalog.each { |item| csv << item.values }
      end

    end

  end

end
