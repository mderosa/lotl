require 'spec_helper'

describe InfoController do

  describe "GET 'whatsandwhys'" do
    it "should be successful" do
      get 'whatsandwhys'
      response.should be_success
    end
  end

end
