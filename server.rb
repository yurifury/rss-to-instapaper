require 'rubygems'
require 'sinatra'
require 'json'

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

require 'instapaper'

get '/' do
  content_type :html
  erb :index
end

get '/rss' do  
  content_type :json
  @rsspaper = RSSPaper.new
  @rsspaper.fetch(params[:url]).to_json
end

get '/auth' do
  erb :auth
end

post '/testauth' do
  base = Instapaper::Base.new(params[:username], params[:password])

  case base.authenticate
  when Instapaper::Response::AuthenticationSuccessResponse
    "Yay"
  else Instapaper::Response::AuthenticationInvalidResponse
    "nooooes"
  end
end

def get_rss(url)

end

class RSSPaper
  attr_reader :feed, :items, :channel, :url
  def fetch(url)
    @url ||= url
    response = ""
    open(@url) do |http|
      response = http.read
    end
    @feed = RSS::Parser.parse(response, false)
    @items = @feed.items
    @channel = @feed.channel
    return self
  end
  
  def to_json
    ret = Array.new()
    @feed.items.each do |rss|
      ret << {
        "title"       => rss.title,
        "link"        => rss.link,
        "description" => rss.description
      }
    end
    ret.to_json
  end
  
  
  
end