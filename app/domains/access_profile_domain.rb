##
# app/services/access_profile_domain.rb
#
# Manages user access to this system and its clickables and other resources

class AccessProfileDomain < ::Factory::DomainsBase

  def reload_access_registry
    # hash = Secure::AccessRegistry.get_ar_permissions_hash
    # puts generate_xml_from_hash(hash, 'my_stuff', 'FileDownload/UserGroups/Pdf')
    Secure::AccessRegistry.ar_reload_configuration_file()
  end

  def get_user_form_options
    SknUtils::PageControls.new({
                                   groups: group_select_options,
                                   roles: role_select_options
                               })
  end
  def group_select_options
    UserGroupRole.select_options
  end
  def role_select_options
    UserRole.select_options
  end


  ##
  # generate xml from a hash of hashes or array of hashes
  # generate xml from a regular hash, with/out arrays
  def generate_xml_from_hash(hash, base_type, collection_key)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(base_type) { process_simple_array(collection_key, hash, xml) }
    end

    builder.to_xml
  end
  # support for #generate_xml_from_hash
  def process_simple_array(label,array,xml)
    array.each do |hash|
      kids,attrs = hash.partition{ |k,v| v.is_a?(Array) }
      xml.send(label,Hash[attrs]) do
        kids.each{ |k,v| process_array(k,v,xml) }
      end
    end
  end

  def system_actions_api(params)
    case params['id']
      when 'xml'
        reload_access_registry
        "AccessRegistry Reloaded"
      when 'purge'
        count = service.purge_storage_objects((Time.now - 10.minutes).to_i)
        "ObjectStorageContainer Purged #{count} Items"
    end
  end

  def generate_system_info_bundle
    ar_resource_type = ar_data_type = 0
    resource_entries = []
    content_entries = []
    c_count = 0
    r_count = 0
    Secure::AccessRegistry.get_ar_resource_keys.each do |ar|

      if Secure::AccessRegistry.get_resource_type(ar)
        ar_data_type += 1
        content_entries << {
            index: '%04d' % (c_count += 1),
            uri: ar.to_s,
            description: Secure::AccessRegistry.get_resource_description(ar),
            options: Secure::AccessRegistry.get_resource_options(ar),
            userdata: Secure::AccessRegistry.get_resource_userdata(ar)
        }
      else
        ar_resource_type += 1
        resource_entries << {
            index: '%04d' % (r_count += 1),
            uri: ar.to_s,
            description: Secure::AccessRegistry.get_resource_description(ar),
            roles: Secure::AccessRegistry.get_resource_roles(ar)
        }
      end

    end

    authenticated_user = (current_user.present? ? true : false )
    xprofile = service.xml_profile_provider.content_profile_for_user(current_user)
    cprofile = service.db_profile_provider.content_profile_for_user(current_user)
    storage_size = Secure::ObjectStorageContainer.instance.size_of_store('Admin')
    storage_keys = Secure::ObjectStorageContainer.instance.list_storage_keys_and_value_class

    result = {
       success: true,
       message: nil,
       authenticated_user: authenticated_user,
       username: (authenticated_user ? current_user.name : 'No authenticated user.'),
       ar_resource_type: ar_resource_type,
       ar_data_type: ar_data_type,
       resource_entries: resource_entries,
       content_entries: content_entries,
       xprofile: xprofile,
       cprofile: cprofile,
       apis_enabled: (authenticated_user and service.current_user_has_access?('#Management')),
       storage_size: storage_size,
       storage_keys: storage_keys
    }

    result
  end

end