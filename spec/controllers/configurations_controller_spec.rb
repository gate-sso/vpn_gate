require 'rails_helper'

RSpec.describe ConfigurationsController, type: :controller do

  describe "GET configuration admin" do
    include SessionsHelper
    it "returns http success" do
      log_in ENV['ADMIN_USERNAME']
      get :show
      expect(response).to have_http_status(:success)      
    end
  end

  describe "GET configuration not admin" do
    include SessionsHelper
    it "redirects to connection" do
      log_in "test"
      get :show
      expect(response).to redirect_to('/')
    end
    it "redirect to root" do
      get :show
      expect(response).to redirect_to('/')
    end
  end

end
