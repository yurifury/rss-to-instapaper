require 'rubygems'
require 'sinatra'

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

get '/' do
  content_type :html
  erb :index
end

post '/add' do
  params[:url]
  rss = get_rss(params[:url])
  erb rss.channel.title
end

def get_rss(url)
  response = ""
  open(url) do |http|
    response = http.read
  end
  RSS::Parser.parse(response, false)
end