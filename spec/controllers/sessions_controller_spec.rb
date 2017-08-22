require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET root" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET root after login" do
    include SessionsHelper
    it "redirect to connection" do
      log_in "test"
      get :new
      expect(response).to redirect_to('/connection')
    end
  end

end

