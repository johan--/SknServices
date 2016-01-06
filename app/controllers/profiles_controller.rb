# All action in this controller are UnSecured
# - Please do not add anything that should not be PUBLIC

class ProfilesController < ApplicationController

  def access_profile_demo
    @page_controls = access_profile_service.handle_demo_page(params)
    if @page_controls.success
      if json_request?
        results = @page_controls.to_hash
        render json: results, status: :accepted, layout: false, content_type: :json and return
      end
    else
      if json_request?
        results = @page_controls.to_hash
        render json: results, status: :conflict, layout: false, content_type: :json and return
      end
    end
  end

  def content_profile_demo
    @page_controls = content_profile_service.handle_demo_page(params)
    if @page_controls.success
      if json_request?
        results = @page_controls.to_hash
        render json: results, status: :accepted, layout: false, content_type: :json and return
      end
    else
      if json_request?
        results = @page_controls.to_hash
        render json: results, status: :conflict, layout: false, content_type: :json and return
      end
    end
  end

  # json api, requires :username and access: [:access, :content]
  # - returns Accessible Content
  # GET
  # Parameters: {"user_options"=>nil, "name"=>"Services.Action.Developer", "description"=>"Developer", "type"=>"EmployeePrimary", "username"=>"skoona", "authenticity_token"=>"mtZTAtBUxcvFqSBLtj7swsEt+OVfdG6Nu6opqkKxw5cHM6FEWPB6Z0GmXgVCyVUMhNCW3e91cKII2rpOhI614g==",
  #             }
  # Parameters: {"user_options"=>nil, "description"=>"Determine which agency documents can be seen", "username"=>"skoona", "topic_value"=>"Agency", "content_value"=>["68601", "68602", "68603"], "content_type"=>"Commission", "content_type_description"=>"Monthly Commission Reports and Files", "topic_type"=>"Agency", "topic_type_description"=>"Agency Actions", "authenticity_token"=>"7jvrpk4eamg4grn04KQt73TwKY6PG2A05w7d7EqMKKRz3hngxrrVxLyNx7oUU5QhMQ1Htj8afhtUfk4IjLNe0Q==",
  #             }
  def accessible_content
    @page_controls = access_profile_service.accessible_content(params)
    results = @page_controls.to_hash
    if @page_controls.package.success
      render json: results, status: :accepted, layout: false, content_type: :json and return
    else
      render json: results, status: :conflict, layout: false, content_type: :json and return
    end
  end


end
