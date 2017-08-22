require 'rails_helper'

RSpec.describe ConnectionsController, type: :controller do

  describe "GET sas" do
    include SessionsHelper
    it "redirect to root" do
      get :get_sas
      expect(response).to redirect_to("/")
    end
    it "return json data" do
      log_in "test"
      get :get_sas
      data = JSON.parse(response.body)
      expect(data.has_key? "sEcho").to eq(true)
      expect(data.has_key? "iTotalRecords").to eq(true)
      expect(data.has_key? "iTotalDisplayRecords").to eq(true)
      expect(data.has_key? "aaData").to eq(true)
      expect(data["iTotalDisplayRecords"]).to eq(data["iTotalRecords"])
      expect(data["iTotalDisplayRecords"]).to eq(data["aaData"].length)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET history" do
    include SessionsHelper
    it "returns all data in database" do
      log_in "test"
      get :get_history
      expect(response).to have_http_status(:success)
    end
  end

end
