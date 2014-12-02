require 'spec_helper'
require 'sessions_helper'

RSpec.describe Admin::TariffsController, :type => :controller do

  describe "GET index" do

    include FactoryGirl::Syntax::Methods
    include SessionsHelper

    before do
      @admin = create(:user)
    end

    it "fails when admin user is not signed in" do
      # visit admin_tariffs_path
      # expect(response).to have_http_status(302)
    end

    it "returns http success when admin user is signed in" do
      sign_in(@admin)
      visit admin_tariffs_path
      expect(response).to have_http_status(:success)
    end

  end

end
