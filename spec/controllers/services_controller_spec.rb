require 'spec_helper'

describe ServicesController do

  @json = { :api_key => 'd578f1ffd50fe2e662e9f36ca5b9ffdf', :api_secret => 'CoccTo3xSnew2' }

  describe "GET getUsers" do
    it "should return correct JSON" do
      jsonstring = {
      }.to_json
      
      get "getUsers", :json => @json.to_json, :format => 'json'
      parsed = JSON.parse(response.body)
      puts parsed['status']
      status = parsed
      status.should == 'success'
    end
  end


  describe "POST 'insertCall'" do
    it "returns http success" do
      post 'insertCall', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "POST 'insertUser'" do
    it "returns http success" do
      post 'insertUser', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "POST 'insertGroup'" do
    it "returns http success" do
      post 'insertGroup', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "POST 'insertComment'" do
    it "returns http success" do
      get 'insertComment', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "POST 'insertTag'" do
    it "returns http success" do
      post 'insertTag', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'updateCallDetail'" do
    it "returns http success" do
      get 'updateCallDetail', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'updateUser'" do
    it "returns http success" do
      get 'updateUser', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'updateGroup'" do
    it "returns http success" do
      get 'updateGroup', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'getCallDetails'" do
    it "returns http success" do
      get 'getCallDetails', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'getGroups'" do
    it "returns http success" do
      get 'getGroups', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'getSubscriptionInfo'" do
    it "returns http success" do
      get 'getSubscriptionInfo', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

  describe "GET 'deleteRecord'" do
    it "returns http success" do
      get 'deleteRecord', :json => @json.to_json, :format => 'json'
      response.should be_success
    end
  end

end
