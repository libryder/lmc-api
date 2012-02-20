class Gist
  include HTTParty
  base_uri 'api.github.com'
end

require 'pp'

class HomeController < ApplicationController

  def docs
  
  end
  
  def gist
    
    @html = Gist.get("/gists", {:id => params[:id]}).body.html_safe
  end

  def fetch_url(url)
    r = Net::HTTP.get_response( URI.parse( url ) )
    if r.is_a? Net::HTTPSuccess
      r.body
    else
      nil
    end
  end


end
