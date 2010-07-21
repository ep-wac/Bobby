require 'spec_helper'

describe "posts/new.html.erb" do
  before(:each) do
    assign(:post, stub_model(Post,
      :new_record? => true,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders new post form" do
    render

    rendered.should have_selector("form", :action => posts_path, :method => "post") do |form|
      form.should have_selector("input#post_title", :name => "post[title]")
      form.should have_selector("textarea#post_body", :name => "post[body]")
    end
  end
end
