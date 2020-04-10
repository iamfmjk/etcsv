require 'etsy'
require 'etcsv'
require 'csv'

RSpec.describe Etcsv do
  it "has a version number" do
    expect(Etcsv::VERSION).not_to be nil
  end

  describe Etcsv::EtsyProducts do

    # it "saves a file into given location" do
    #   Etcsv::EtsyProducts.set_etsy_credentials('a5aanamotjzoke2cglybced8', 'd3gpalxbnt')
    #   catalog_file = Etcsv::EtsyProducts.new('iuliiakolomiiets')
    #   file_path = "../catalog-sv/product_file01.csv" # use ruby's tempfile path here
    #   catalog_file.export_catalog(file_path)
    #   expect(File.exist?(file_path)).to be_truthy
    # end
    let(:username) { 'iuliiakolomiiets' }
    let(:etsy_products) { Etcsv::EtsyProducts.new(username) }

    it "retrieves the user details" do
      user_details = double("user_details")

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(etsy_products.user).to eq(user_details)
    end

    it "retrieves shop info" do
      shop_info = double("shop info")
      user_details = double("user_details", shop: shop_info )

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(etsy_products.shop).to eq(shop_info)

    end

  end
end
