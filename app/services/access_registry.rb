##
# app/services/access_registry.rb
#
# Reads a control file from <rails_root>/config/accessregistry.xml into a control hash
# offers static routines to callers which validate access to controlled resources
#
# Author: James Scott, Jr. <jscott@skoona.net>
# Date: 2/27/2013
##
#
# The intentions of this module is to control permissions for all of the app in the following ways.
# - 1. Global Action (Clickables) Permissions
# - 2. Page Access
# - 3. Page Action Permission
# - 4. Content Access Permissions
#
# A possible Role Scheme could be:
#  Role: 1. 'Global.<actionName>'
#        2. 'Global.<PageName>'
#        3. '<PageName>.<actionName>'
#        4. 'Content.<contentName>.<accessAction>'
#
# A possible URI scheme could be:
#  URI: 1. 'Global.<actionName>'
#       2. '<controller>/<actionName>'  or '<menuName>/<controllerName>'
#       3. '<pageName>.<actionName>'
#       4. '<contentName>.<accessAction>'
#
# The User profile object has methods to facilitate access queries; via the
##
#   <APPLICATION-PROTECTED-RESOURCE-URI>  <-- mapping --> <EXTERNALLY CONTROLLED ROLE NAME>
#   ================================================================================
# A) Each clickable or protected resource in the application is given an id or URI name, when created in 
#    the application.  This name is absolutely unique to the protected resource, and must be assigned by the 
#    developer/designer.
#
# B) The AccessRegistry maps this name to an unique security role name, which reflects the intent or content 
#    of the protected resource.  While mapping the two URIs, additional attributes are available for
#    assignment to clarify the relationship and/or mapping.  Attributes like the classic CREATE/READ/UPDATE/DELETE,
#    and other attributes which could convey more restrictive access and ownership permissions.
#
# C) The full security implementation automatically verifies access to Page or Controller/Action resources.  All
#    other authorization controls must be implemented by the developer using #has_access?|??? methods provided.
##


## control hash structure
#
#  access_registry = {
#    "uri" = {
#      "secured" => true,
#      "description" => "some description",
#      "CREATE" => {
#        "role name" => ["options","options",...],        
#        "role n" => []
#      },
#      "READ" => {
#        "role name" => ["options","options",...],        
#        "role n" => []
#      },
#      "UPDATE" => {
#        "role name" => ["options","options",...],        
#        "role n" => []
#      },
#      "DELETE" => {
#        "role name" => ["options","options",...],        
#        "role n" => []
#      }
#    }, ...
#  }
#


class AccessRegistry

  CRUD_MODES = ["CREATE","READ","UPDATE","DELETE"].freeze
	@@ar_permissions = Secure::AccessRegistryUtility.new("accessregistry").from_xml()

  def initialize
    # not needed as this is a static class
    raise NotImplementedError, "Do Not Instantiate this class"
  end

  ##
  # Core Methods
  #
  def self.get_resource_description(resource_uri)
    @@ar_permissions[resource_uri]["description"]
  end  
  def self.get_ar_resource_keys
    @@ar_permissions.keys
  end
  def self.get_ar_permissions_hash
    @@ar_permissions
  end

  ##
  # Match specific CRUD
  # User Role MUST match CRUD Role AND
  # User options MUST match Resource Options if Resource Options are present
  #
  def self.check_role_permissions? (user_roles, resource_uri, crud_mode="READ", options=nil)
    user_roles = [user_roles] unless user_roles.kind_of?(Array)
    result = false

    if is_secured? resource_uri then
      result = catch :found do
        user_roles.each do |user_role|
          result  = role_in_resource_crud?(user_role, resource_uri, crud_mode)
          #puts "\tCHECK_ROLE_PERMISSIONS?(#{user_role}->#{crud_mode}) returned=#{result}"
          next unless result
          opts    = has_options_ary?(user_role,resource_uri,crud_mode)
          result  = role_in_resource_crud_with_option?(user_role,resource_uri,crud_mode,options) if result and opts
          #puts "\t\tCHECK_ROLE_PERMISSIONS?(#{crud_mode}) returned=#{result}"
          throw :found, true if result
        end # end user roles
        false    # false if nothing  is thrown, i.e not found
      end # end catch
    else 
      # TODO: Enable logging of all access which get this pass
      Rails.logger.info("#{self.class.name}.#{__method__}() Not Registered: #{resource_uri} with opts=#{options}") if Rails.logger.present?
      puts("#{self.class.name}.#{__method__}() Not Registered: #{resource_uri} with opts=#{options}")
      result = true
    end
    
    result
  end

  ##
  # Match Any CRUD
  # User Role MUST match CRUD Role AND
  # User options MUST match Resource Options if Resource Options are present
  #
  def self.check_access_permissions? (user_roles, resource_uri, options=nil)
    user_roles = [user_roles] unless user_roles.kind_of?(Array)
    result = false
    value = false
     if is_secured? resource_uri then
       result = catch :found do
         user_roles.each do |user_role|
            CRUD_MODES.each do |crud_mode|
              value  = role_in_resource_crud?(user_role,resource_uri, crud_mode)
              #puts "\tCHECK_ACCESS_PERMISSIONS?(#{user_role}->#{crud_mode}) returned=#{value}"
              next unless value
              opts    = has_options_ary?(user_role,resource_uri,crud_mode)
              value  = role_in_resource_crud_with_option?(user_role,resource_uri,crud_mode,options) if value and opts
              #puts "\t\tCHECK_ACCESS_PERMISSIONS?(#{crud_mode}) returned=#{value}"
              throw :found, true if value
            end # end crud modes
         end # end user roles
         false    # false if nothing  is thrown, i.e not found
       end # end catch
     else
       # TODO: Enable logging of all access which get this pass
       Rails.logger.info("#{self.class.name}.#{__method__}() Not Registered: #{resource_uri} with opts=#{options}") if Rails.logger.present?
       puts("#{self.class.name}.#{__method__}() Not Registered: #{resource_uri} with opts=#{options}")
       result = true
     end
     
    result
  end

  def self.is_secured?(resource_uri)
    # if the uri is not present its considered to have public access
    return false unless @@ar_permissions.has_key?(resource_uri)
    @@ar_permissions[resource_uri]["secured"] ||  false
  end

  def self.warden_bypass?(resource_uri)
    # Warden must consider all things true (secured) unless its present and  defined to be different
    (@@ar_permissions.has_key?(resource_uri) && !@@ar_permissions[resource_uri]["secured"]) # prefer the actual value or use the default
  end

  protected

  def self.has_options_ary?(role_name, resource_uri, crud_mode="READ")
    !@@ar_permissions[resource_uri][crud_mode][role_name].empty?
  end

  def self.role_in_resource_crud?(role_name, resource_uri, crud_mode)
    @@ar_permissions[resource_uri].has_key?(crud_mode) and @@ar_permissions[resource_uri][crud_mode].has_key?(role_name)
  end

  def self.role_in_resource_crud_with_option?(role_name, resource_uri, crud_mode, option)
    option = [option] unless option.kind_of?(Array)
    option.collect {|value| @@ar_permissions[resource_uri][crud_mode][role_name].include?(value) }.any?
  end

end
