require File.dirname(__FILE__) + '/spec_helper'

describe "RSSPaper" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
  end
  
  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
  end
  
  describe "RSS parser" do
    
    before(:each) do
      @rsspaper = RSSPaper.new
      @rsspaper.fetch('spec/fixtures/test.rss')
    end
    
    it "fetches a feed from a URL" do
      @rsspaper.channel.title.should eql("RyanHoliday.net")
    end
    
    it "saves the URL" do
      @rsspaper.url.should eql('spec/fixtures/test.rss')
    end
    
    it "returns valid json" do
      JSON.parse(@rsspaper.to_json).should be_true
    end
  
  end
  
end