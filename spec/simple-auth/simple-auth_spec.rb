require 'spec_helper'

describe "Simple auth spec" do
  before(:each) do
    @session_hash = {}
    @session = AdminSession.new(@session_hash)
  end

  it "should authorize" do
    @session.authorized?(:admin).should be_false
    @session.authorized?.should be_false

    @session.role = "admin"
    @session.password = "123456"
    @session.save
      
    @session_hash.should_not be_empty
    @session.authorized?(:admin).should be_true
  end
  
  it "should authorize all roles" do
    @session.role = "admin"
    @session.password = "123456"
    @session.save

    @session.role = "manager"
    @session.password = "123456"
    @session.save
    
    @session.authorized?.should be_true    
    @session.authorized?(:admin).should be_true
    @session.authorized?(:manager).should be_true    
    
    @session.logout(:admin)
    @session.authorized?(:admin).should be_false
    @session.authorized?(:manager).should be_true     
    
    @session.logout_all
    @session.authorized?(:admin).should be_false
    @session.authorized?(:manager).should be_false    
    @session.authorized?.should be_false    
  end
  
  it "attributes= should work" do
    proc { @session.attributes = {} }.should_not raise_error
    proc { @session.attributes = {:role => "test", :password => 'test'} }.should_not raise_error
    @session.role.should eq('test')
    @session.password.should eq('test')    
  end
end