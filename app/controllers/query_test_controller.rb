class QueryTestController < ApplicationController

  def index
    unless cookies[:api_key].blank?
      @api_key = cookies[:api_key]
    end
    
    unless cookies[:api_secret].blank?
      @api_secret = cookies[:api_secret]
    end
    
    @api_key ||= nil
    @api_secret ||= nil
  end

end
