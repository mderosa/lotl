require 'spec_helper'

describe Project do

  describe "validation requirements" do
    before(:each) do
      @params = {:name => "project name", :repository => ""}
      @proj = Project.new(@params)
    end

    it "default project object should pass validation" do
      @proj.should be_valid
    end

    it "name should not be blank" do 
      @proj.name = "     "
      @proj.should_not be_valid
    end

    it "name should have a maximum length of 255 characters" do
      @proj.name = ("a" * 333)
      @proj.should_not be_valid
    end

    it "if not blank a repository can have the form of a git hub repository string" do
      @proj.repository = "git@github.com:mderosa/lotl.git"
      @proj.should be_valid
    end

    it "the repository can come in as nil and pass" do
      @proj.repository = nil
      @proj.should be_valid
    end

    it "we should not be able to set repository to a blank string" do
      p = Project.new(:name => "somthing", :repository => "   ")
      p.repository.should be_nil
    end
  end

end
