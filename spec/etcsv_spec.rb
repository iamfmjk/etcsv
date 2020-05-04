require 'spec_helper'
require 'tmpdir'

RSpec.describe Etcsv do
  it "has a version number" do
    expect(Etcsv::VERSION).not_to be nil
  end

  describe Etcsv::EtsyProducts do

    def tmpname
      t = Time.now.strftime("%Y%m%d")
      "etcsv-#{t}-#{$$}-#{rand(0x100000000).to_s(36)}-fd.csv"
    end

    let(:username) { 'iuliiakolomiiets' }
    let(:etsy_products) { Etcsv::EtsyProducts.new(username) }
    let(:brand) {'shiborifm'}
    let(:csv_path) { File.join Dir.tmpdir, tmpname }
    let(:all_listings) {
      [
        double("listing", result: {"listing_id"=>796021753, "state"=>"active", "user_id"=>831, "category_id"=>nil, "title"=>"Title One", "description"=>"Description One", "creation_tsz"=>1586974375, "ending_tsz"=>1597515175, "original_creation_tsz"=>1586974375, "last_modified_tsz"=>1586974377, "price"=>"20.25", "currency_code"=>"USD", "quantity"=>1, "sku"=>[], "tags"=>["drink coaster"], "category_path"=>["Home & Living", "Kitchen & Dining", "Drink & Barware", "Drinkware", "Coasters"], "materials"=>["Fabric"], "shop_section_id"=>268, "featured_rank"=>nil, "state_tsz"=>1586974375, "url"=>"https://www.etsy.com/listing/796021753/coiled-rope-coasters-set-of-4-washable?utm_source=etcsv&utm_medium=api&utm_campaign=api", "views"=>0, "num_favorers"=>0, "shipping_template_id"=>642, "processing_min"=>1, "processing_max"=>1, "who_made"=>"i_did", "is_supply"=>"false", "when_made"=>"2010_2019", "item_weight"=>"8", "item_weight_unit"=>"oz", "item_length"=>"11", "item_width"=>"9", "item_height"=>"1", "item_dimensions_unit"=>"in", "is_private"=>false, "recipient"=>nil, "occasion"=>nil, "style"=>nil, "non_taxable"=>false, "is_customizable"=>true, "is_digital"=>false, "file_data"=>"", "should_auto_renew"=>false, "language"=>"en-US", "has_variations"=>false, "taxonomy_id"=>1060, "taxonomy_path"=>["Home & Living", "Kitchen & Dining", "Drink & Barware", "Drinkware", "Coasters"], "used_manufacturer"=>false, "is_vintage"=>false}),
        double("listing", result: {"listing_id"=>796020929, "state"=>"active", "user_id"=>831, "category_id"=>nil, "title"=>"Title Two", "description"=>"Description two", "creation_tsz"=>1586974244, "ending_tsz"=>1597515044, "original_creation_tsz"=>1586974244, "last_modified_tsz"=>1586974525, "price"=>"20.25", "currency_code"=>"USD", "quantity"=>1, "sku"=>[], "tags"=>["drink coaster", "tea coaster", "coffee coaster", "hostess gift", "washable coasters", "set of 4 coasters", "rustic kitchen decor", "new home gift", "beverage coaster", "custom coasters", "rope coasters", "coiled rope decor", "fuchsia pink"], "category_path"=>["Home & Living", "Kitchen & Dining", "Drink & Barware", "Drinkware", "Coasters"], "materials"=>["Fabric"], "shop_section_id"=>268, "featured_rank"=>8, "state_tsz"=>1586974244, "url"=>"https://www.etsy.com/listing/796020929/coiled-rope-coasters-set-of-4-washable?utm_source=etcsv&utm_medium=api&utm_campaign=api", "views"=>0, "num_favorers"=>0, "shipping_template_id"=>642, "processing_min"=>1, "processing_max"=>1, "who_made"=>"i_did", "is_supply"=>"false", "when_made"=>"2010_2019", "item_weight"=>"8", "item_weight_unit"=>"oz", "item_length"=>"11", "item_width"=>"9", "item_height"=>"1", "item_dimensions_unit"=>"in", "is_private"=>false, "recipient"=>nil, "occasion"=>nil, "style"=>nil, "non_taxable"=>false, "is_customizable"=>true, "is_digital"=>false, "file_data"=>"", "should_auto_renew"=>false, "language"=>"en-US", "has_variations"=>false, "taxonomy_id"=>1060, "taxonomy_path"=>["Home & Living", "Kitchen & Dining", "Drink & Barware", "Drinkware", "Coasters"]})
        ]
      }

    let(:listing_pictures) {
      {
        796021753 => [
          double(
            "picture03", result: {
              "listing_image_id"=>2312573397,
              "creation_tsz"=>1586974376,
              "listing_id"=>796021753,
              "rank"=>1,
              "url_75x75"=>"https://i.etsystatic.com/18213281/d/il/0a9bb5/2312573397/il_75x75.2312573397_qmo6.jpg?version=0",
              "url_170x135"=>"https://i.etsystatic.com/18213281/d/il/0a9bb5/2312573397/il_170x135.2312573397_qmo6.jpg?version=0",
              "url_570xN"=>"https://i.etsystatic.com/18213281/r/il/0a9bb5/2312573397/il_570xN.2312573397_qmo6.jpg",
              "url_fullxfull"=>"https://i.etsystatic.com/18213281/r/il/0a9bb5/2312573397/il_fullxfull.2312573397_qmo6.jpg"
            }
          ),
          double(
            "picture04", result: {
              "listing_image_id"=>2264973070,
              "creation_tsz"=>1586974376,
              "listing_id"=>796021753,
              "rank"=>2,
              "url_75x75"=>"https://i.etsystatic.com/18213281/d/il/a604f5/2264973070/il_75x75.2264973070_8e28.jpg?version=0",
              "url_170x135"=>"https://i.etsystatic.com/18213281/d/il/a604f5/2264973070/il_170x135.2264973070_8e28.jpg?version=0",
              "url_570xN"=>"https://i.etsystatic.com/18213281/r/il/a604f5/2264973070/il_570xN.2264973070_8e28.jpg",
              "url_fullxfull"=>"https://i.etsystatic.com/18213281/r/il/a604f5/2264973070/il_fullxfull.2264973070_8e28.jpg"
            }
          )
        ],
        796020929 => [
          double(
            "picture01",
            result: {"listing_image_id"=>2264970190, "creation_tsz"=>1586974245, "listing_id"=>796020929, "rank"=>1, "url_75x75"=>"https://i.etsystatic.com/18213281/d/il/99c9a8/2264970190/il_75x75.2264970190_kmpl.jpg?version=0", "url_170x135"=>"https://i.etsystatic.com/18213281/d/il/99c9a8/2264970190/il_170x135.2264970190_kmpl.jpg?version=0", "url_570xN"=>"https://i.etsystatic.com/18213281/r/il/99c9a8/2264970190/il_570xN.2264970190_kmpl.jpg", "url_fullxfull"=>"https://i.etsystatic.com/18213281/r/il/99c9a8/2264970190/il_fullxfull.2264970190_kmpl.jpg"}
          ),
          double(
            "picture02", result: {"listing_image_id"=>2312571393, "creation_tsz"=>1586974245, "listing_id"=>796020929, "rank"=>4, "url_75x75"=>"https://i.etsystatic.com/18213281/d/il/546cef/2312571393/il_75x75.2312571393_swhs.jpg?version=0", "url_170x135"=>"https://i.etsystatic.com/18213281/d/il/546cef/2312571393/il_170x135.2312571393_swhs.jpg?version=0", "url_570xN"=>"https://i.etsystatic.com/18213281/r/il/546cef/2312571393/il_570xN.2312571393_swhs.jpg", "url_fullxfull"=>"https://i.etsystatic.com/18213281/r/il/546cef/2312571393/il_fullxfull.2312571393_swhs.jpg"}
          )
        ]
      }
    }

    let(:exported_listings) {
      [
        {
          "id"=>"etcsv-796021753",
          "title"=>"Title One",
          "description"=>"Description One",
          "price"=>"20.25",
          "inventory"=>"1",
          "link"=>"https://www.etsy.com/listing/796021753/coiled-rope-coasters-set-of-4-washable",
          "brand"=>"shiborifm",
          "condition"=>"new",
          "availability"=>"in stock",
          "image_link"=>"https://i.etsystatic.com/18213281/r/il/0a9bb5/2312573397/il_fullxfull.2312573397_qmo6.jpg", "additional_image_link"=>"https://i.etsystatic.com/18213281/r/il/a604f5/2264973070/il_fullxfull.2264973070_8e28.jpg"
        },
        {
          "id"=>"etcsv-796020929",
          "title"=>"Title Two",
          "description"=>"Description two",
          "price"=>"20.25",
          "inventory"=>"1",
          "link"=>"https://www.etsy.com/listing/796020929/coiled-rope-coasters-set-of-4-washable",
          "brand"=>"shiborifm",
          "condition"=>"new",
          "availability"=>"in stock",
          "image_link"=>"https://i.etsystatic.com/18213281/r/il/99c9a8/2264970190/il_fullxfull.2264970190_kmpl.jpg",
          "additional_image_link"=>"https://i.etsystatic.com/18213281/r/il/546cef/2312571393/il_fullxfull.2312571393_swhs.jpg"
        }
      ]
    }

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

    it "retrieves active listings by shop id and exports them to CSV file" do
      shop_id = double("shop id")
      shop_info = double("shop info", id: shop_id, name: brand)
      user_details = double("user_details", shop: shop_info )

      expect(Etsy).to receive(:user).with(username).and_return(user_details)
      expect(Etsy::Listing).to receive(:find_all_by_shop_id)
        .with(shop_id, limit: 1000)
        .and_return(all_listings)

      all_listings.each do |listing|
        expect(Etsy::Image).to receive(:find_all_by_listing_id)
          .with(listing.result["listing_id"])
          .and_return(listing_pictures[listing.result["listing_id"]])
        end

      etsy_products.export_catalog(csv_path)

      expect(File.exist?(csv_path)).to be_truthy

      all_rows = CSV.read(csv_path, headers: true)

      all_rows.each.with_index do |row, i|
        expect(row.to_h).to eq(exported_listings[i])
      end
    end
  end
end
