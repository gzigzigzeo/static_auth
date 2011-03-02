require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_model/conversion'
require 'active_model/naming'
require 'active_model/attribute_methods'
require 'digest/sha1'
require 'digest/md5'

module SimpleAuth
  class Session
    include ActiveModel::Conversion
    include ActiveModel::AttributeMethods
    extend ActiveModel::Naming
    
    def persisted?; false; end

    class_inheritable_accessor :encryption_methods
    self.encryption_methods = {
      :plain => proc { |value| value.reverse },
      :sha1 => proc { |value| Digest::SHA1.hexdigest(value).to_s },
      :md5 => proc { |value| Digest::MD5.hexdigest(value).to_s }
    }

    attr_accessor :role, :password

    class << self
      def roles(*args)    
        self.defined_roles = self.defined_roles.concat(args).uniq
      end

      def password_for(role, password)
        check_role(role)
        self.defined_passwords[role] = password
      end
      
      def encrypt(value)
        encryption_methods[encryption_method].call(value.to_s)
      end
      
      def set_encryption_method(method)
        raise ArgumentError, "Unknown encryption method #{method.to_s} (#{self.encryption_methods.keys.join(', ')}). You can add method through class inheritable accessor #encryption_methods." unless self.encryption_methods.keys.include?(method)
        self.encryption_method = method
      end      
    end

    attr_accessor :session
    def initialize(session)
      self.session = session
    end

    def save    
      if !self.role.blank? && self.class.defined_roles.include?(self.role.to_sym)
        self.session[session_key_for(role)] = self.class.encrypt(self.password)
        true
      else
        false
      end
    end  

    def authorized?(role = nil)
      unless role.nil?
        self.session[session_key_for(role)] == password_for(role)
      else      
        self.class.roles.any? { |r| self.session[session_key_for(r)] == password_for(r) }
      end
    end

    def logout(role)
      check_role(role)
      self.session[session_key_for(role)] = nil
    end

    def logout_all
      self.class.defined_roles.each { |r| logout(r) }
    end

    def attributes=(attrs)
      attrs.each { |key, value| send(:"#{key}=", value) }
    end
       
    protected
    def password_for(role)
      role = role.to_sym
      check_role(role)
      raise ArgumentError, "Password for #{role} is not defined" unless self.class.defined_passwords.keys.include?(role)
      if self.class.defined_passwords[role].is_a?(Proc)        
        self.class.defined_passwords[role].call
      else
        self.class.encrypt(self.class.defined_passwords[role])        
      end
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
    
    class_inheritable_array :defined_roles
    self.defined_roles = []

    class_inheritable_hash :defined_passwords  
    self.defined_passwords = {}

    class_inheritable_accessor :session_key
    self.session_key = "SIMPLEAUTH"

    class_inheritable_accessor :encryption_method
    self.encryption_method = :plain
  end
end