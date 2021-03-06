##
# lib/providers/db_profile_provider.rb
#
# ContentProfile from DB
#
# Storage thru Factory

module Providers
  class DBProfileProvider < ::Factory::ProvidersBase

    PROVIDER_PREFIX = self.name

    def initialize(params={})
      super(params)
    end

    def self.provider_type
      PROVIDER_PREFIX
    end

    def provider_type
      PROVIDER_PREFIX
    end

    ##
    # Retrieve Profiles
    ##
    def content_profile_for_user(usr_profile, beaned=false)
      hsh = collect_content_profile_bean(usr_profile)
      beaned ? Utility::ContentProfileBean.new(hsh) : hsh
    end

    ##
    # Creation Methods
    ##

    #   "id"=>"profile entry id",
    #   "pak"=>"72930134e6222904010dd4d6fb5f1887",
    #   "username"=>"bptester",
    #   "description"=>"Samples",
    #   "topic_type_id"=>"1",
    #   "topic_type_value"=>["1"],
    #   "content_type_id"=>"3",
    #   "content_type_value"=>["9", "8", "7"],
    #   "button"=>"content-entry-modal"
    # }
    def create_content_profile_entry_by_ids(params)
      tchoices = TopicType.where(id: params['topic_type_id'].to_i).includes(:topic_type_opts).map do |rec|
        {type: rec.attributes,
         opts: rec.topic_type_opts.where(id: params['topic_type_value'].collect(&:to_i)).map(&:attributes)}
      end
      cchoices = ContentType.where(id: params['content_type_id'].to_i).includes(:content_type_opts).map do |rec|
        {type: rec.attributes,
         opts: rec.content_type_opts.where(id: params['content_type_value'].collect(&:to_i)).map(&:attributes)}
      end
      cpe = create_content_profile_entry_for(params['description'], tchoices, cchoices)
      assign_content_profile_entry_to(ContentProfile.where(person_authentication_key: params['pak']).first, cpe)
    end

    # {topic_value: [],  content_value: [], content_type: "LicensedStates", topic_type: "Branch",
    #  topic_type_description: "", content_type_description: "",
    #  description: 'Determine which States branches are authorized to operate in.'
    # }
    #
    # => [{:type=>{"name"=>"LicensedStates", "description"=>"Business Operational Metric", "value_data_type"=>"Integer"},
    #      :opts=>[{"value"=>"9", "description"=>"Ohio", "type_name"=>"LicensedStates"},
    #              {"value"=>"21", "description"=>"Michigan", "type_name"=>"LicensedStates"}]
    #     }]
    # topic_choice,content_choice expect one hash; apply first if needed
    def create_content_profile_entry_for(cpe_desc, topic_choice, content_choice)
      cvs = content_choice.is_a?(Hash) ? content_choice : content_choice.first
      tvs = topic_choice.is_a?(Hash) ? topic_choice : topic_choice.first
      ContentProfileEntry.create!({
          description: cpe_desc,
          content_value: cvs[:opts].map {|v| v["value"] }.flatten,
          content_type: cvs[:type]["name"],
          content_type_description: cvs[:type]["description"],
          topic_value: tvs[:opts].map {|v| v["value"] }.flatten,
          topic_type: tvs[:type]["name"],
          topic_type_description: tvs[:type]["description"]
      })
    end

    def create_content_profile_for(user_p, profile_type_name )
      ContentProfile.create!({
         person_authentication_key: user_p.person_authenticated_key,
         profile_type_id: ProfileType.find_by(name: profile_type_name).try(:id),
         authentication_provider: "SknService::Bcrypt",
         username: user_p.username,
         display_name: user_p.display_name,
         email: user_p.email
      })
    end

    def update_content_profile_for(pak, profile_type_id )
      cp = ContentProfile.where(person_authentication_key: pak).first.update!(profile_type_id: profile_type_id)
      delete_storage_object(pak)
      cp
    end

    def destroy_content_profile_by_pak(pak)
      cb = ContentProfile.where(person_authentication_key: pak).first.destroy!
      delete_storage_object(pak)
      cb
    end

    def destroy_content_profile_entry_with_pak_and_id(pak, cpe_id)
      cp = ContentProfile.where(person_authentication_key: pak).first
      cpe = ContentProfileEntry.find(cpe_id)
      remove_content_profile_entry_from(cp, cpe)
    end

    def assign_content_profile_entry_to(profile_obj, profile_entry_obj)
      profile_obj.content_profile_entries << profile_entry_obj
      profile_obj.save!
      profile_obj.content_profile_entries.reload
      delete_storage_object(profile_obj.person_authentication_key)
      profile_obj
    end

    def get_existing_profile(usr_prf)
      raise Utility::Errors::NotFound, "Invalid UserProfile!" unless usr_prf.present?
      get_prebuilt_profile(usr_prf.person_authenticated_key)
    end

  protected
    ##
    # ContentProfile
    ##

    def remove_content_profile_entry_from(profile_obj, profile_entry_obj)
      profile_obj.content_profile_entries.destroy(profile_entry_obj)
      profile_obj.save!
      profile_obj.content_profile_entries.reload
      delete_storage_object(profile_obj.person_authentication_key)
      profile_obj
    end

    def remove_dates_and_ids_from_choices(choices)
      targets = ["id", "created_at", "updated_at", "content_type_id", "topic_type_id"]
      choices.each do |choice|
        choice[:type].delete_if {|k,v| k.in?(targets) }
        choice[:opts].each {|opt| opt.delete_if {|k,v| k.in?(targets)}}
      end
      choices
    end

    def remove_dates_from_choices(choices)
      targets = ["created_at", "updated_at"]
      choices.each do |choice|
        choice[:type].delete_if {|k,v| k.in?(targets) }
        choice[:opts].each {|opt| opt.delete_if {|k,v| k.in?(targets)}}
      end
      choices
    end

    # Retrieves users content profile in ResultBean
    def collect_content_profile_bean(user_profile)
      raise Utility::Errors::NotFound, "Invalid User Object!" unless user_profile.present?
      cpobj = get_existing_profile(user_profile)
      return  cpobj if cpobj

      results = {}
      ctxp = ContentProfile.includes(:content_profile_entries).find_by( person_authentication_key: user_profile.person_authenticated_key)

      unless ctxp.nil?
        results =  ctxp.entry_info_with_username(user_profile).merge({ success: true })
      else
        results = {
            success: false,
            message: "No content profile data available for #{user_profile.display_name}",
            username: user_profile.username,
            entries:[]
        }
      end
      update_storage_object(user_profile.person_authenticated_key, results) unless results[:entries].empty?

      Rails.logger.debug("#{self.class.name.to_s}.#{__method__}() returns: #{results.to_hash}")
      results
      
    rescue Exception => e
      Rails.logger.error "#{self.class.name}.#{__method__}() Klass: #{e.class.name}, Cause: #{e.message} #{e.backtrace[0..4]}"
      delete_storage_object(user_profile.person_authenticated_key) if user_profile.present?
      {
        success: false,
        message: e.message,
        username: 'unknown',
        entries:[]
      }
    end

  end
end