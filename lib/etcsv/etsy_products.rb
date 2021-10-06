module Etcsv

  class RequestsLimitError < StandardError; end

  class EtsyProducts

    MAX_REQUESTS_PER_SECOND = 20
    MIN_SLEEP_TIME = 1.0 / MAX_REQUESTS_PER_SECOND
    MAX_RETRIES = 5

    def initialize (username)
      @username = username
    end

    def self.set_etsy_credentials (api_key, api_secret)
      Etsy.protocol = 'https'
      Etsy.api_key = api_key
      Etsy.api_secret = api_secret
    end

    def self.retry_with_backoff(tries_counter = 1, &block)
      return yield
    rescue Etsy::ExceededRateLimit
      if tries_counter <= MAX_RETRIES
        sleep MIN_SLEEP_TIME ** 1 / tries_counter
        retry_with_backoff(tries_counter + 1, &block)
      else
        raise RequestsLimitError
      end
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

    def shop_image
      return @shop_image ||= self.shop.image_url
    end

    def listings
      return @listings ||= self.class.retry_with_backoff do
        Etsy::Listing.find_all_by_shop_id(self.shop.id, :limit => 1000)
      end
    end

    def export_catalog(csv_path)
      fb_fields = {"brand" => self.brand, "condition" => "new", "availability" => "in stock"}
      header = ['id', 'title', 'description', 'price', 'inventory', 'link', 'brand', 'condition', 'availability', 'image_link', 'additional_image_link']
      CSV.open(csv_path, 'w') do |csv|
        csv << header

        self.listings.each do |listing|
          listing_result = listing.result
          catalog_item = listing_result.slice("title", "description", "price")
          catalog_item.merge!(fb_fields)
          catalog_item["id"] = listing_result["listing_id"].to_s.prepend("etcsv-")
          catalog_item["inventory"] = listing_result["quantity"]
          catalog_item["link"] = listing_result["url"].split("?")[0].sub(/www/, @brand)
          
          images = self.class.retry_with_backoff do
            Etsy::Image.find_all_by_listing_id(listing_result["listing_id"])
          end
          primary_image = ""
          album = []
          images.each do |img|
            if img.result["rank"] == 1
              primary_image = img.result["url_fullxfull"]
            else
              album << img.result["url_fullxfull"]
            end
          end
          catalog_item.merge!("image_link" => primary_image, "additional_image_link" => album.join(","))

          csv << catalog_item.slice(*header).values
        end
      end
    end

  end
end
