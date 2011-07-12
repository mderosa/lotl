require 'spec_helper'

describe ApplicationHelper do

  it "should not show menu when we are at entrance or project#index page" do
    actual = show_menu?({:controller => "projects", :action => "index"})
    actual.should be_false
  end

  it "should show the task selections only when we are it the tasks controller" do
    actual = show_menu?(:controller => "tasks", :action => "index")
    actual.should be_true
  end

end
