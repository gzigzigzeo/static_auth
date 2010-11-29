require 'active_support/concern'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_model/conversion'
require 'active_model/naming'
require 'active_model/attribute_methods'
require 'sha1'

module SimpleAuth
  class Session
    include ActiveModel::Conversion
    include ActiveModel::AttributeMethods
    extend ActiveModel::Naming
    
    def persisted?; false; end

    class_inheritable_array :defined_roles
    self.defined_roles = []

    class_inheritable_hash :defined_passwords  
    self.defined_passwords = {}

    class_inheritable_accessor :session_key
    self.session_key = "SIMPLEAUTH"

    attr_accessor :role, :password

    class << self
      def roles(*args)    
        self.defined_roles = self.defined_roles.concat(args).uniq
      end

      def password_for(role, password)
        check_role(role)
        self.defined_passwords[role] = password
      end
    end

    attr_accessor :session
    def initialize(session)
      self.session = session
    end

    def save    
      if self.class.defined_roles.include?(self.role.to_sym)
        self.session[session_key_for(role)] = SHA1.sha1(self.password).to_s
      end
    end  

    def authorized?(role = nil)
      unless role.nil?
        self.session[session_key_for(role)] == SHA1.sha1(password_for(role)).to_s
      else
        self.class.roles.any? { |r| self.session[session_key_for(r)] == SHA1.sha1(password_for(r)).to_s }
      end
    end

    def logout(role)
      check_role(role)
      self.session[session_key_for(role)] = nil
    end

    def logout_all
      self.class.defined_roles.each { |r| logout(r) }
    end

    protected
    def password_for(role)
      role = role.to_sym
      check_role(role)
      raise ArgumentError, "Password for #{role} is not defined" unless self.class.defined_passwords.keys.include?(role)
      self.class.defined_passwords[role].is_a?(Proc) ? self.class.defined_passwords[role].call : self.class.defined_passwords[role]
    end

    private
    def check_role(role)
      self.class.check_role(role)
    end

    def self.check_role(role)
      raise ArgumentError, "Role #{role} is not defined" unless self.defined_roles.include?(role)
    end        
    
    def session_key_for(role)
      :"#{self.class.session_key}_#{role}"
    end
  end
end