Given /^a Rails app$/ do
  %w{ app app/controllers app/models app/views }.each do |pattern|
    Dir[pattern].should_not be_empty
  end
end

Given /^I have the generator in "([^"]*)"$/ do |folder|
  folder = File.expand_path(File.join(Rails.root, folder))
  File.exists?(folder+"/USAGE").should be_true
end

Then /^I can instanciate the models "([^"]*)"$/ do |models|
  models.split(" ").each do |model|
    puts model
    #(model.constantize).table_name.should == model.underscore.pluralize
  end
end

Given /^I have bobby installed$/ do
  actual_output = File.read('Gemfile')
  actual_output.should(match(/bobby/))
end

When /^I invoke "([^"]*)" generator$/ do |generator|
  f = open("|rails generate #{generator}")
  foo = f.read()
  f.close

  foo.should include('bobby_create_tables')
  foo.should include('roles')
  foo.should include('permissions')
  foo.should include('group_users')
end
