require 'spec_helper'

describe Tariff do

  include FactoryGirl::Syntax::Methods
  
  before do
    @accom_type = create(:accommodation_type)
    @tariff = Tariff.new(
        tariff_category: 'C3',
        tariff: 8000,
        effective_date: Date.new(2010, 11, 30),
        accommodation_type_id: @accom_type.id,
        with_power_points: true,
        price_class: :normal_price
      )
  end

  subject { @tariff }

  it { should respond_to(:tariff_category) }
  it { should respond_to(:tariff) }
  it { should respond_to(:effective_date) }
  it { should respond_to(:end_date) }
  it { should respond_to(:accommodation_type_id) }
  it { should respond_to(:accommodation_type) }
  it { should respond_to(:with_power_points) }
  it { should respond_to(:price_class) }

  it "must be valid" do
    expect(@tariff).to be_valid
  end

  it "must have a valid factory" do
    # tariff_factory = build(:tariff, accommodation_type: @accom_type)
    # expect(tariff_factory).to be_valid
    # expect(tariff_factory.accommodation_type).to eq(@accom_type)
  end

  describe "Validating tariff attributes" do

    # it "must ensure the tariff_category have a valid format" do
    #   @tariff.tariff_category = 'Z1'
    #   expect(@tariff).not_to be_valid
    #   @tariff.tariff_category = 'A 2'
    #   expect(@tariff).not_to be_valid
    #   @tariff.tariff_category = 'F9'
    #   expect(@tariff).not_to be_valid
    # end

    # it "must ensure the end_date cannot precede the effective_date" do
    #   @tariff.end_date = @tariff.effective_date - 1
    #   expect(@tariff).not_to be_valid
    # end

    # it "must accept a valid effective_date and end_date" do
    #   @tariff.end_date = @tariff.effective_date + 1
    #   expect(@tariff).to be_valid
    # end

    # it "must ensure the tariff is present" do
    #   @tariff.tariff = 0
    #   expect(@tariff).not_to be_valid
    # end
  end

  describe "Find tariffs over the requested period" do
    before do
      @tariff1 = create(:tariff,
          tariff_category: 'D3',
          tariff: 8000,
          effective_date: Date.new(2015, 8, 1),
          end_date: Date.new(2015, 8, 9),
          accommodation_type: @accom_type,
          with_power_points: true,
          price_class: :in_season_price)
      @tariff2 = create(:tariff,
          tariff_category: 'D3',
          tariff: 8200,
          effective_date: Date.new(2015, 8, 10),
          end_date: Date.new(2015, 8, 14),
          accommodation_type: @accom_type,
          with_power_points: true,
          price_class: :normal_price)
      @tariff3 = create(:tariff,
          tariff_category: 'D3',
          tariff: 8400,
          effective_date: Date.new(2015, 8, 15),
          end_date: nil,
          accommodation_type: @accom_type,
          with_power_points: true,
          price_class: :special_price)
    end

    it "must find booking prices for a period that will be terminated" do
      eff_date = Date.new(2015, 8, 3)
      end_date = Date.new(2015, 8, 8)
      puts "\n\nFind prices between #{eff_date.to_s} and #{end_date.to_s}"
      prices = Tariff.find_prices(@accom_type ,eff_date, end_date)
      expect(prices.count).to eq(1)
      expect(prices[0][:tariff]).to eq(8000)
      puts "Prices (a): #{prices.inspect}"
    end

    it "must find booking prices for a period between other tariff periods" do
      eff_date = Date.new(2015, 8, 10)
      end_date = Date.new(2015, 8, 13)
      puts "\n\nFind prices between #{eff_date.to_s} and #{end_date.to_s}"
      prices = Tariff.find_prices(@accom_type ,eff_date, end_date)
      expect(prices.count).to eq(1)
      expect(prices[0][:tariff]).to eq(8200)
      puts "Prices (b): #{prices.inspect}"
    end

    it "must find booking prices within the last tariff period" do
      eff_date = Date.new(2015, 8, 16)
      end_date = Date.new(2015, 8, 17)
      puts "\n\nFind prices between #{eff_date.to_s} and #{end_date.to_s}"
      prices = Tariff.find_prices(@accom_type ,eff_date, end_date)
      expect(prices.count).to eq(1)
      expect(prices[0][:tariff]).to eq(8400)
      puts "Prices (c): #{prices.inspect}"
    end

    it "must find booking prices spanning two tariff periods" do
      eff_date = Date.new(2015, 8, 8)
      end_date = Date.new(2015, 8, 12)
      puts "\n\nFind prices between #{eff_date.to_s} and #{end_date.to_s}"
      prices = Tariff.find_prices(@accom_type ,eff_date, end_date)
      expect(prices.count).to eq(2)
      expect(prices[0][:tariff]).to eq(8200)
      expect(prices[1][:tariff]).to eq(8000)
      puts "Prices (d): #{prices.inspect}"
    end

    it "must find booking prices spanning three tariff periods" do
      eff_date = Date.new(2015, 8, 8)
      end_date = Date.new(2015, 8, 15)
      puts "\n\nFind prices between #{eff_date.to_s} and #{end_date.to_s}"
      prices = Tariff.find_prices(@accom_type ,eff_date, end_date)
      expect(prices.count).to eq(3)
      expect(prices[0][:tariff]).to eq(8400)
      expect(prices[1][:tariff]).to eq(8200)
      expect(prices[2][:tariff]).to eq(8000)
      puts "Prices (e): #{prices.inspect}"
    end

  end


end