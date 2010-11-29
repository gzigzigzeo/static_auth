require 'spec_helper'

describe "Simple auth spec" do
  before(:each) do
    @session_hash = {}
    @session = AdminSession.new(@session_hash)
  end

  it "should authorize" do
    @session.authorized?(:admin).should be_false

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
    
    @session.authorized?(:admin).should be_true
    @session.authorized?(:manager).should be_true    
    
    @session.logout(:admin)
    @session.authorized?(:admin).should be_false
    @session.authorized?(:manager).should be_true     
    
    @session.logout_all
    @session.authorized?(:admin).should be_false
    @session.authorized?(:manager).should be_false    
  end
end