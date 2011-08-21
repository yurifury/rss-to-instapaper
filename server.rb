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
  params[:url] = "http://feeds.feedburner.com/rudiusmedia/rch" # Dev link
  rss = get_rss(params[:url])
  content_type :json
  rss.to_json
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
  response = ""
  open(url) do |http|
    response = http.read
  end
  RSS::Parser.parse(response, false)
end

class RSS::Rss
  def to_json
    ret = Array.new()
    items.each do |rss|
      ret << {
        "title"       => rss.title,
        "link"        => rss.link,
        "description" => rss.description
      }
    end
    ret.to_json
  end
end