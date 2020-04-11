require 'etsy'
require 'etcsv'
require 'csv'

RSpec.describe Etcsv do
  it "has a version number" do
    expect(Etcsv::VERSION).not_to be nil
  end

  describe Etcsv::EtsyProducts do

    # it "saves a file into given location" do
    #   Etcsv::EtsyProducts.set_etsy_credentials('')
    #   catalog_file = Etcsv::EtsyProducts.new('iuliiakolomiiets')
    #   file_path = "../catalog-sv/product_file01.csv" # use ruby's tempfile path here
    #   catalog_file.export_catalog(file_path)
    #   expect(File.exist?(file_path)).to be_truthy
    # end
    let(:username) { 'iuliiakolomiiets' }
    let(:etsy_products) { Etcsv::EtsyProducts.new(username) }
    let(:brand) {'brand'}

    it "retrieves the user details" do
      user_details = double("user_details")

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(etsy_products.user).to eq(user_details)
    end

    it "retrieves shop info" do
      shop_id = double("shop id")
      shop_info = double("shop info", id: shop_id)
      user_details = double("user_details", shop: shop_info )

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(etsy_products.shop).to eq(shop_info)
      expect(etsy_products.shop.id).to eq(shop_id)

    end

    it "sets a brand name from the shop data" do
      shop_info = double("shop info", name: brand)
      user_details = double("user_details", shop: shop_info )

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(etsy_products.brand).to eq(brand)

    end

    it "retrieves active listings by shop id" do
      shop_id = double("shop id")
      shop_info = double("shop info", id: shop_id, name: brand)
      user_details = double("user_details", shop: shop_info )
      all_listings = []
      csv_path = '../catalog-sv/all_listings.csv'

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(Etsy::Listing).to receive(:find_all_by_shop_id).with(shop_id, limit: 1000).and_return(all_listings)

      etsy_products.export_catalog(csv_path)
    end

  end
end
