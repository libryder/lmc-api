require 'digest/sha1'

class ServicesController < ApplicationController
  
  before_filter :api_auth, :scrub_external_ids

# ############################################
#
# PRIVATE METHODS
#
# ############################################
  def send_response
    if not params[:type].blank?
      case params[:type]
        when "xml"
          render :xml => @response
        else
          render :json => @response
      end
    else
      render :json => @response
    end   
  end
  
  def create_timestamps insert = false
    ret = {}
    if insert
      ret[:created] = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    end
    
    ret[:modified] = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    
    ret
    
  end
  
  def generate_error error_message
    {
      "status"  =>  "error",
      "error_message" =>  error_message
    }  
  end
  
  # *****************************************
  #
  # ext_id() and strip_ext_id
  #		These methods simply return the formatted 
  # 	external ID. master_node is prepended to 
  # 	the passed in value to safeguard duplicate 
  #		ID's across organizations
  #
  def ext_id id
    "#{@master_node}|#{id}"
  end
  
  def strip_ext_id id
    id.split('|')[1]
  end
  
  def external_id_exists?(record_type, eid)
    cnt = record_type.constantize.find_by_external_id(eid)
    if cnt.nil?
      false
    else
      true
    end
  end
  
  # *****************************************
  #
  # scrub_external_ids()
  #		This method scrubs all *_external_id's 
  # 	posted and resolves them to the actual
  #		id of the object in the databse.  
  #
  #		Does not return anything as it is meant 
  #		to be part of before_filter
  #
  def scrub_external_ids
    unless params[:criteria][:external_user_id].blank?
     id = ext_id params[:criteria][:external_user_id]
     user = User.where('external_id = ?', id)
     if user.count == 0
        @response = generate_error "User with external id #{strip_ext_id id} cannot be found."
        send_response
     else
      params[:criteria][:user_id] = user.first.id
     end
     params[:criteria].delete 'external_user_id'
    end
    
    unless params[:criteria][:external_call_detail_id].blank?
      id = ext_id params[:criteria][:external_call_detail_id]
      call_detail = CallDetail.where('external_id = ?', id)
      if call_detail.count == 0
        @response = generate_error "Call detail with external id #{strip_ext_id id} cannot be found."
        send_response
      else
        params[:criteria][:call_detail_id] = call_detail.first.id
      end      
      params[:criteria].delete 'external_call_detail_id'
    end
    
    unless params[:criteria][:external_ouid].blank?
      id = ext_id params[:criteria][:external_ouid]
      ou = OrganizationalUnit.where('external_id = ?', id)
      if ou.count == 0
        @response = generate_error "Group with external id #{strip_ext_id id} cannot be found."
        send_response
      else
        params[:criteria][:ouid] = ou.first.id
      end
      params[:criteria].delete 'external_ouid'
    end    
    
    unless params[:external_id].blank?
      @find_by_ext_id = true
      params[:id] = params[:external_id]
    end
     
  end
  
  # *****************************************
  #
  # validate_required_params()
  #   This method takes an array and verifies 
  #   that the contained keys exist in the criteria 
  #   param that is posted to the controller. 
  #
  #   Returns a array of missing parameters. 
  #
  def validate_required_params required_params
    @find_by_ext_id = false
    missing_params = []
    
    required_params.each { |k| 
      if k.to_s == "id" and !params[:external_id].blank?
        @find_by_ext_id = true
        params[:id] = params[:external_id]
        next
      end

      unless params[:criteria].has_key?(k)
        missing_params << k
      end
    }
    
    missing_params
  end

  # *****************************************
  #
  # param_validate()
  #		High-level scrubbing method to verify 
  #		passed parameters are acceptable according
  #		to allowed_parameters.yml. 
  #
  #		This method also maps parameters from the 
  #		criteria array to their associative database
  #		column names. 
  #
  def param_validate type
    error_message = nil    
    params[:sort_order] ||= 'asc'
    
    in_statement = [@master_node]
    # List of parameters acceptable to the API and their respective database column names
    allowed_parameters = ALLOWED_PARAMS[type]['incoming'] 

    unless (params[:criteria].keys-allowed_parameters.keys).empty?
      error_message = "Unrecognized parameter(s): [#{(params[:criteria].keys-allowed_parameters.keys).join","}]"
    end
    
    if params[:criteria].has_key? 'external_id'
      params[:criteria][:external_id] = ext_id params[:criteria][:external_id]
    end

		if params[:criteria].has_key? 'assign_to'
			email = params[:criteria].delete :assign_to
			user = User.find_by_username(email)
			if User.nil?
				error_message = "Could not find user with email #{email}."
			else
				params[:criteria][:assign_to] = user.id
			end
		end

    if params[:criteria].has_key? 'group_id'
      unless ["14", "15", "16", "17", "19", "20", "21"].include? params[:criteria][:group_id].to_s
        error_message = "Invalid group_id. Please see https://api.logmycalls.com/docs for documentation."
      end
    end
    
    if params[:criteria].has_key? 'ouid'
      if (not @ous.include? params[:criteria][:ouid]) && (params[:criteria][:ouid].to_s != @master_node.to_s)
        error_message = "You are not authorized to access group with ouid #{params[:criteria][:ouid]}. #{@ous}"
      end      
    else
    	#why is there an else?  
    end
    
    # Accept a dry_run parameter to roll back any changes made to the databse. 
    # This allows safe testing of the API with real data
    unless params[:dry_run].blank?
      if params[:dry_run] == 'true'
        @dry_run = true
      else
        @dry_run = false
      end
    end
    
    #ensure 
    if params[:sort_by].blank?
    	params[:sort_by] = 'id'
    else
    	params[:sort_by] = allowed_parameters[params[:sort_by]]
			if params[:sort_by].blank?
				error_message = "Invalid sort parameter."
			end
    end
    
    @ous.each { |k| in_statement << k.to_s }
    # Remap parameters to database column names
    criteria = Hash[params[:criteria].map { |k, v| [allowed_parameters[k], v] }]

    { :allowed_parameters => allowed_parameters, :criteria => criteria, :error_message => error_message, :auth_ous => in_statement }
  
  end
  
  
  # *****************************************
  #
  # api_auth()
  #   Authenticate user and store the OU's they
  #   have access to in a session var for more
  #   efficient access. 
  #
  def api_auth
    # check if we received an api key and secret and attempt to 
    if params[:api_key].nil? or params[:api_secret].nil?
      @auth = false
      @error_message = "Error authenticating."
    else
      # set class variables and delete the params as they are no longer needed
      @api_key = params.delete("api_key")
      @api_secret = params.delete("api_secret")
      
      cookies[:api_key] = { :value => @api_key, :expires => 1.year.from_now }
      cookies[:api_secret] = { :value => @api_secret, :expires => 1.year.from_now }
      
      #find parent ou based on key and secret. this is the main auth method
      @parent_ou = OrganizationalUnit.where("api_key='#{@api_key}' and api_secret='#{@api_secret}' and master_node=1")

      if @parent_ou.count == 0
        @auth = false
        @error_message = "You are not authorized to use this service."
      else
        # user has successfully authenticated. from here we will look for a session that contains
        # all children OU's and if it doesn't exist, then create one
        @auth = true;
        session_var = CakeSession.where("id = ?", @api_key + @api_secret).first

        if !session_var.nil?
          @ous = ActiveSupport::JSON.decode(session_var.data).to_a.map do |a| a.to_s end
          @master_node = @parent_ou.first.id.to_s
        else
          #get first descendents of ou then find all of their children recursively
          children = @parent_ou.first.children
          ou_children = (children + children.map(&:children)).flatten
          
          #put the children ouid's in a new array
          @ous = Array.new
          ou_children.each do |child|
            @ous.push child.id
          end
          
          #create new session
          session_data = @ous.to_json
          session = CakeSession.new({"id" => "#{@api_key}#{@api_secret}", "data" => session_data, "expires" => Time.now.to_i + 1200})
          session.save
          
          @ous = Array(@ous)
          @master_node = @parent_ou.first.id.to_s
       
        end

        # the class variable @ous will be available to the rest of the controller
      end
    end
    
    # halt any further processing as an authentication error has occurred
    if defined? @error_message
      @response = { "status" => "error", "error_message" => @error_message }
      respond_to do |format|
        format.json { render :json => @response }
      end      
    end
    
    if params[:criteria].blank?
      params[:criteria] = {}
    end
    
  end
  
# ############################################
#
# PUBLIC METHODS
#
# ############################################

  
  # *****************************************
  #
  # insertCall()
  #
  def insertCall
  
    required_params = [:ouid, :duration, :calldate, :caller_id, :tracking_number, :ringto_number]
    missing_params = validate_required_params(required_params)

    unless missing_params.count == 0
      @response = generate_error "Missing parameter(s): #{missing_params}"
      send_response
      return
    end      
    
    validate_hash = param_validate "call_details"
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
      send_response 
      return
    end  

    #save record
    ouid = params[:criteria][:ouid]
    
    #sets start and end date of call
    t = Time.parse params[:criteria][:calldate]
    validate_hash[:criteria][:start_date] = t.to_s
    validate_hash[:criteria][:end_date] = (t + validate_hash[:criteria][:duration].to_i.seconds).to_s
    validate_hash[:disposition] = "ANSWERED"

    # ensure external_id is unique      
    unless validate_hash[:criteria]['external_id'].blank?
      if external_id_exists?("CallDetail", validate_hash[:criteria]['external_id'])
        @response = generate_error "Duplicate external ID."
        send_response
        return
      end
    end  

    req_object = CallDetail.create validate_hash[:criteria].merge(create_timestamps true)
    
    @response = {
      "status"  =>  "success",
      "call_detail" => req_object
    }
        
    send_response
    
  end

  # *****************************************
  #
  # uploadAudio()
  #
  def uploadAudio
    error_message = '';
    #@response = params
    required_params = [:call_detail_id, :audio]
    required_params.each { |k| 
      if k.to_s == "id" and !params[:external_id].blank?
        find_by_ext_id = true
        params[:id] = params[:external_id]
        next
      end
      error_message << "Missing parameter: #{k}. " unless params.has_key?(k) 
    }
    find_by_ext_id = false
    
    #find record
    if find_by_ext_id
      req_object = CallDetail.find_by_external_id ext_id params[:external_id]
    else
      req_object = CallDetail.find_by_id params[:call_detail_id]
    end
    
    #check if ou was found; if not, return error
    if req_object.nil?
      @response = generate_error "Call detail with id #{params[:call_detail_id]} was not found."
    else
      ouid = req_object.organizational_unit_id.to_s
      call_detail_id = req_object.id
      object_id = req_object.id
      
      if ouid != @master_node && !@ous.include?(ouid)
        @response = generate_error "You are not authorized to update this call detail. It's possible the group this call was assigned to no longer exists. (id: #{object_id})"
      else
        audio_file = AudioFile.new({
          :title => params['audio'].original_filename,
          :wav  =>  params['audio']
        })
        audio_file.save
    
        # get filename from newly uploaded mp3
        filename = audio_file.wav_file_name
        filebase = File.basename(audio_file.wav_file_name).split('.')[0]
        ext = "mp3"
        
        new_recording = Recording.create({
          :call_detail_id =>  call_detail_id,
          :organizational_unit_id	=> 	ouid,
          :file_name 				=> 	filebase,
          :created					=>	'NOW()',
          :modified				=>	'NOW()', 
          :status					=>	'active'
        })
        
        req_object.update_attribute("monitored_file_name", filename)
        
        @response = {
          "status"  =>  "success",
          "call_detail" => req_object
        }      
      end
    end

    send_response
  end
  
  # *****************************************
  #
  # insertTag()
  #
  def insertUser
    required_params = [:ouid, :email, :first_name, :last_name, :group_id]
    missing_params = validate_required_params(required_params)

    unless missing_params.count == 0
      @response = generate_error "Missing parameter(s): #{missing_params}"
      send_response
      return
    end
    
    validate_hash = param_validate "users"
    #validate_hash[:error_message] = validate_hash[:auth_ous]
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
      send_response 
      return
    end

    # id is allowed, but we want to remove it for new objects
    params[:criteria].delete('id') unless params[:criteria][:id].nil?
    
    #check for existing user
    user_find = User.where("username = ?", params[:criteria][:email])
    unless user_find.count == 0
      @response = generate_error "A user with this email address #{params[:criteria][:email]} already exists." 
      send_response
      return
    end

    #if not validate_hash[:error_message].nil? || error_message.length > 1
    if validate_hash[:error_message] != '' && !validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
    else
      #save record
      ouid = params[:criteria][:ouid]
      
      params[:criteria][:password] ||= SecureRandom.hex(6)
      validate_hash[:criteria][:password] = Digest::SHA1.hexdigest('Th3_B1g_Br0wn_F0x_J\/mp3d_0v3r_Th3_L4zy_D0g' + params[:criteria][:password])
      
      req_object = User.create validate_hash[:criteria]

      #acl = Aro.create [ "foreign_key" => req_object.id, "alias" => req_object.username, "model" => "User" ]
      @response = {
        "status"  =>  "success",
        "password"  =>  params[:criteria][:password],
        "call_detail" => req_object
      }
    end
        
    send_response  
  
  end

  # *****************************************
  #
  # insertGroup()
  #
  def insertGroup
    validate_hash = {:error_message => ''}
    
    required_params = [:parent_ouid, :name]
    required_params.each { |k| validate_hash[:error_message] += "Missing parameter: #{k}. " unless params[:criteria].has_key?(k) }

    # id is allowed, but we want to remove it for new objects
    params[:criteria].delete('id') unless params[:criteria][:id].nil?
    
    #check for existing user

    validate_hash = param_validate "groups" if validate_hash[:error_message].length == 0

    #if not validate_hash[:error_message].nil? || error_message.length > 1
    if validate_hash[:error_message] != '' && !validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
    else
      #save record
      ouid = params[:criteria][:parent_ouid]
      
      # ensure external_id is unique      
      unless validate_hash[:criteria]['external_id'].blank?
        if external_id_exists?("OrganizationalUnit", validate_hash[:criteria]['external_id'])
          @response = generate_error "Duplicate external ID."
          send_response
          return
        end
      end      
      
      req_object = OrganizationalUnit.create validate_hash[:criteria]

      @response = {
        "status"  =>  "success",
        "group" => req_object
      }
    end
        
    send_response    
  end

  # *****************************************
  #
  # insertComment()
  #
  def insertComment
    validate_hash = {:error_message => ''}
    
    required_params = [:user_id, :call_detail_id, :comment]
    required_params.each { |k| validate_hash[:error_message] += "Missing parameter: #{k}. " unless params[:criteria].has_key?(k) }

    # id is allowed, but we want to remove it for new objects
    params[:criteria].delete('id') unless params[:criteria][:id].nil?
    
    validate_hash = param_validate "comments" if validate_hash[:error_message].length == 0

    #if not validate_hash[:error_message].nil? || error_message.length > 1
    if validate_hash[:error_message] != '' && !validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
    else
      #check that call_detail exists
      call_find = CallDetail.find_by_id validate_hash[:criteria]['call_detail_id']
      if call_find.nil?
        validate_hash[:error_message] += "Call detail #{params[:criteria][:call_detail_id]} does not exist."
      else
      
      end
    
      #save record

      ouid = call_find.organizational_unit_id.to_s
      
      # ensure we have access to assign a comment to posted OUID
      unless @ous.include? ouid or @master_node == ouid
        @response = generate_error "You do not have access to update call detail assigned to ouid #{ouid}"
        send_response
        return
      end

      # ensure external_id is unique      
      unless validate_hash[:criteria]['external_id'].blank?
        if external_id_exists?("Comment", validate_hash[:criteria]['external_id'])
          @response = generate_error "Duplicate external ID."
          send_response
          return
        end
      end
      req_object = Comment.create validate_hash[:criteria].merge(create_timestamps true)

      @response = {
        "status"  =>  "success",
        "comment" => req_object
      }
    end  
    
    send_response
  end
  
  # *****************************************
  #
  # insertTag()
  #
  def insertTag
  
    required_params = [:tag, :user_id]
    missing_params = validate_required_params(required_params)

    unless missing_params.count == 0
      @response = generate_error "Missing parameter(s): #{missing_params}"
      send_response
      return
    end      
    
    validate_hash = param_validate "tags"
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
      send_response 
      return
    end  

    # verify user belongs to organization
    user = User.find_by_id validate_hash[:criteria]['user_id']
    
    if user.nil?
      @response = generate_error "User with that ID does not exist."
      send_response
      return      
    elsif (not @ous.include? user.organizational_unit_id.to_s) && (user.organizational_unit_id.to_s != @master_node)
      @response = generate_error "User with that ID does not belong to your organization."
      send_response
      return
    end
    
    # ensure external_id is unique      
    unless validate_hash[:criteria]['external_id'].blank?
      if external_id_exists?("Keyword", validate_hash[:criteria]['external_id'])
        @response = generate_error "Duplicate external ID."
        send_response
        return
      end
    end
    
    req_object = Keyword.create validate_hash[:criteria].merge(create_timestamps true)

    @response = {
      "status"  =>  "success",
      "tag" => req_object
    }
        
    send_response  
  end
	
	
  # *****************************************
  #
  # updateCallDetail()
  #
  def updateCallDetail
    if params[:id].blank? && params[:external_id].blank?
      @response = generate_error "Missing parameter(s): [id] or [external_id]"
      send_response
      return    
    end
    
    validate_hash = param_validate "call_details"
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
      send_response 
      return
    end  
    
    #update record
    if @find_by_ext_id
      req_object = CallDetail.find_by_external_id ext_id params[:external_id]
    else
      req_object = CallDetail.find_by_id params[:id]
    end
    
    #check if ou was found; if not, return error
    if req_object.nil?
      @response = generate_error "Call detail with id #{params[:id]} was not found."
    else
      ouid = req_object.organizational_unit_id.to_s

      object_id = req_object.id
      if ouid != @master_node and !@ous.include?(ouid)
        @response = generate_error "You are not authorized to update this call detail. It's possible the group this call was assigned to no longer exists. (id: #{object_id})"
      else
      
        #sets start and end date of call
        begin
          t = Time.parse validate_hash[:criteria]['created']
        rescue
          @response = generate_error "Call date must be in the following example format: 2005-9-14 5:24:44."
          send_response
          return
        end
        
        validate_hash[:criteria][:start_date] = t.to_s
        validate_hash[:criteria][:end_date] = (t + validate_hash[:criteria][:duration].to_i.seconds).to_s      
        
        req_object = CallDetail.update object_id, validate_hash[:criteria]
        
        @response = {
          "status"  =>  "success",
          "call_detail" => req_object
        }
      end
    end
  
    send_response  
  end

  # *****************************************
  #
  # updateUser()
  #
  def updateUser
    if params[:external_id].blank? and params[:id].blank?
      missing_params = [:id]
      @response = generate_error "Missing parameter(s): #{missing_params}"
      send_response
      return      
    end  
    
    validate_hash = param_validate "users"
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
      send_response 
      return
    else
      #update record
      if @find_by_ext_id
        req_object = User.find_by_external_id ext_id params[:external_id]
      else
        req_object = User.find_by_id params[:id]
      end
      
      #check if ou was found; if not, return error
      if req_object.nil?
        @response = generate_error "User with id #{params[:id]} was not found."
      else
        ouid = req_object.organizational_unit_id.to_s

        object_id = req_object.id
        if ouid != @master_node and !@ous.include?(ouid)
          @response = generate_error "You are not authorized to update this user. (id: #{object_id})"
        else
          req_object = User.update object_id, validate_hash[:criteria].merge(create_timestamps(false))

          @response = {
            "status"  =>  "success",
            "user" => req_object
          }      
        end
      end
      
    end
    
    send_response
  end

  # *****************************************
  #
  # updateGroup()
  #
  def updateGroup    
    if params[:external_id].blank? and params[:id].blank?
      missing_params = [:id]
      @response = generate_error "Missing parameter(s): #{missing_params}"
      send_response
      return      
    end  
    
    validate_hash = param_validate "groups"
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
    else
      #update record
      if @find_by_ext_id
        ou = OrganizationalUnit.find_by_external_id ext_id params[:external_id]
      else
        ou = OrganizationalUnit.find_by_id params[:id]
      end
      
      #check if ou was found; if not, return error
      if ou.nil?
        @response = generate_error "Group with id #{params[:id]} was not found."
      else
        object_id = ou.id.to_s
        if object_id != @master_node and !@ous.include?(object_id)
          @response = generate_error "You are not authorized to update this group. (ouid: #{object_id})"
        else
          ou = OrganizationalUnit.update object_id, params[:criteria]

          @response = {
            "status"  =>  "success",
            "group" => ou
          }      
        end
      end
      

    end
    
    send_response  
    
  end

  # *****************************************
  #
  # getCallDetails()
  #
  def getCallDetails
    
    # set defaults only if they are not passed in
    params[:limit] ||= 100
    params[:start] ||= 0
    
    # get hash with criteria, allowed_parameters, and error_message back
    validate_hash = param_validate "call_details"
    
    if validate_hash[:criteria]['organizational_unit_id'].blank?
      validate_hash[:error_message] ||= "ouid or external_ouid are required."
    end
    
    if not validate_hash[:error_message].nil?
      @response = generate_error "#{validate_hash[:error_message]}"
    else    
      # Render our json response based on a success or failure of api call
      
      unless validate_hash[:criteria]['start_date'].blank?
        start_date = validate_hash[:criteria].delete 'start_date'
      end
      
      # the find method to render as json
      return_objs = CallDetail.where(validate_hash[:criteria]).limit(params[:limit]).order("#{params[:sort_by]} #{params[:sort_order]}").offset(params[:start])#.select(validate_hash[:allowed_parameters].values)

      unless start_date.nil?
        return_objs = return_objs.where('start_date like ?', "%#{start_date}%")
      end

      @response = {
        "status"  =>  "success",
        "matches" =>  return_objs.length,
        "results" => return_objs
      }
    end
    send_response
    
  end

  # *****************************************
  #
  # getGroups()
  #
  def getGroups
    # set defaults only if they are not passed in
    params[:limit] ||= 100
    params[:start] ||= 0

  	unless params[:criteria][:stores_only].blank?
  		store_flag = params[:criteria][:stores_only] 
  		params[:criteria][:stores_only] = store_flag ? 1 : 0
  	end


    # get hash with criteria, allowed_parameters, and error_message back
    validate_hash = param_validate "groups"
    #validate_hash[:error_message] = store_flag    
    # Render our json response based on a success or failure of api call
    if validate_hash[:error_message] != nil
      @response = {
        "status"  =>  "error",
        "error_message" =>  validate_hash[:error_message]
      }
    else
     
      # the find method to render as json
      return_objs = OrganizationalUnit.where(validate_hash[:criteria]).where("id IN (?)", validate_hash[:auth_ous]).limit(params[:limit]).offset(params[:start]).order("#{params[:sort_by]} #{params[:sort_order]}")#.select(validate_hash[:allowed_parameters].values)

      @response = {
        "status"  =>  "success",
        "matches" =>  return_objs.length,
        "results" => return_objs
      }
    end
    
    send_response    
  end
  
  # *****************************************
  #
  # getSubscriptionInfo()
  #
  def getSubscriptionInfo
    
    ou = OrganizationalUnit.where('id = ?', @master_node).first
    subscription = ChargifyProduct.where('id = ?', ou.chargify_product_id)
    
    @response = { "subscription" => subscription }
    
    send_response
    
  
  end

  # *****************************************
  #
  # getUsers()
  #
  def getUsers
    
    # set defaults only if they are not passed in
    params[:limit] ||= 100
    params[:start] ||= 0

    # get hash with criteria, allowed_parameters, and error_message back
    validate_hash = param_validate "users"
    
    if validate_hash[:criteria][:organizational_unit_id].blank?
      #validate_hash[:criteria][:organizational_unit_id] = @ous
    end

    # Render our json response based on a success or failure of api call
    if validate_hash[:error_message] != nil
      @response = {
        "status"  =>  "error",
        "error_message" =>  validate_hash[:error_message]
      }
    else
      # the find method to render as json
      
      return_objs = User.where(validate_hash[:criteria]).limit(params[:limit]).order("#{params[:sort_by]} #{params[:sort_order]}").offset(params[:start])

      @response = {
        "status"  =>  "success",
        "matches" =>  return_objs.length,
        "results" => return_objs
      }

    end
    
    send_response
    
  end

  # *****************************************
  #
  # deleteRecord()
  #
  def deleteRecord
    error_message = []
    del_by_ext_id = false
    
    required_params = [:type, :id, :ouid]
    required_params.each { |k| 
      if k.to_s == "id" and !params[:external_id].blank?
        del_by_ext_id = true
        params[:id] = params[:external_id]
        next
      end
      error_message << "Missing parameter: #{k}. " unless params.has_key?(k) 
    }
    
    unless ALLOWED_PARAMS['delete_types'].include? params[:type]
      error_message << "Unable to delete object type: #{params[:type]}"
    end
    
    if error_message.count > 0
      @response = generate_error error_message.join('| ')
    else
      #delete record      
      if del_by_ext_id
        del_object = ALLOWED_PARAMS['model_map'][params[:type]].constantize.find_by_external_id ext_id params[:id]
      else
        del_object = ALLOWED_PARAMS['model_map'][params[:type]].constantize.find_by_id params[:id]
      end
      
      if del_object.nil?
        error_message << "Could not find #{params[:type]} with id: #{params[:id]}"
        @response = generate_error error_message.join('| ')
      else
      
        object_id = del_object.ouid
        
        if object_id != @master_node and !@ous.include?(object_id)
          error_message << "You are not authorized to delete this #{params[:type]}. (ouid: #{object_id})"
          @response = generate_error error_message.join('| ')
        else
          del_object.update_attribute('status', 'deleted')

          @response = {
            "status"  =>  "success",
            "deleted_item" => del_object
          }      
        end
      
      end

    end
    
    send_response 
  
  end

end
