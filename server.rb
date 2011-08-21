require 'rubygems'
require 'sinatra'

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

require 'net/https'

get '/' do
  content_type :html
  erb :index
end

post '/add' do
  params[:url] = "http://feeds.feedburner.com/rudiusmedia/rch" # Dev link
  rss = get_rss(params[:url])
  @items = rss.items
  @channel = rss.channel
  erb :list
end

get '/auth' do
  erb :auth
end

post '/testauth' do
  res = Net::HTTP.post_form(URI.parse("http://www.instapaper.com/api/authenticate"),
  {'username' => params[:username], 'password' => params[:password]})
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    "Good!"
  else
    "Oh noes, incorrect username/pass"
  end
end

def get_rss(url)
  response = ""
  open(url) do |http|
    response = http.read
  end
  RSS::Parser.parse(response, false)
end