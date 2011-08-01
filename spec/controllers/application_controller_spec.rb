require 'spec_helper'

describe ApplicationController do

  describe "cache controller" do
    it "should maintain a singleton cache object" do
      a1 = ApplicationController.new
      a2 = ApplicationController.new
      a1.cache.should_not be_nil
      a1.cache.should eq(a2.cache)
    end

    it "should expire cache objects given an expiration time in seconds" do
      a = ApplicationController.new
      a.cache.write "greeting", "hello", :expires_in => 4.seconds
      a.cache.read("greeting").should eq("hello")
      sleep 5
      a.cache.read("greeting").should be_nil
    end
  end
end
