require 'spec_helper'
require 'sessions_helper'

RSpec.describe Admin::TariffsController, :type => :controller do

  describe "GET index" do

    include FactoryGirl::Syntax::Methods
    include SessionsHelper

    before do
      # @admin = create(:user)
      # @accommodation_type = create(:accommodation_type)
    end

    it "fails when admin user is not signed in" do
      # visit admin_accommodation_type_tariffs_path(@accommodation_type)
      # puts "Response status: #{response.status}"
      # expect( visit admin_accommodation_type_tariffs_path(@accommodation_type) ).to redirect_to(signin_path)
    end

    # it "returns http success when admin user is signed in" do
    #   sign_in(@admin)
    #   visit admin_accommodation_type_tariffs_path(@accommodation_type)
    #   expect(response).to have_http_status(:success)
    # end

  end

end
