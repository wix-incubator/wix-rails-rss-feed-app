class AppController < ActionController::Base
	
	before_filter :require_instance

	def widget
		@settings = get_settings_from_db.value.html_safe
	end

	def settings  
		@settings = get_settings_from_db.value.html_safe
		cookies[:instance] = params[:instance]
	end

	def settingsupdate
		key = get_settings_key

		settings = get_settings_from_db
		settings.key = key
		settings.value = params[:settings]
		settings.save()

		render :json => {}, :status => 200
	end

	private

	def get_settings_key
		key = @instance['instanceId'] + ':'

		if (params[:origCompId])
			key = key + params[:origCompId]
		else
			key = key + params[:compId]
		end
		
		return key 
	end

	def get_settings_from_db
		begin
			key = get_settings_key
			settings = Settings.find(key)
		rescue ActiveRecord::RecordNotFound, Exception => e
		  	settings = Settings.new(:key => '', :value => '{}')
		end

		return settings
	end

	def require_instance
		@instance = nil

		if params[:instance]
			@instance = params[:instance]
		elsif cookies[:instance]
			@instance = cookies[:instance]
		end

		return validateInstance
	end

	def validateInstance
		redirect_to('/invalid-instance') unless !@instance.nil?
			
		if (!parse_instance)
			redirect_to('/invalid-instance')
		end
	end

	def parse_instance
 		secret = '4b751959-d637-4400-a426-7da12612d5a8'

 		begin
 			signature, encoded_json = @instance.split('.', 2)
	 	
		    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, secret, encoded_json)
		 	
		    # bug in ruby. why are there '=' chars on urlsafe_encode ?!	
		    my_signature = Base64.urlsafe_encode64(hmac).gsub('=','')

		    if (signature != my_signature)
		    	raise "Invalid signature"
		    end

	   		# Need to add Base64 padding to make base64 decode work in Ruby. (ref: http://stackoverflow.com/questions/4987772/decoding-facebooks-signed-request-in-ruby-sinatra)
		   	encoded_json_hack = encoded_json + ('=' * (4 - encoded_json.length.modulo(4)))
		 
		    json_str = Base64.urlsafe_decode64(encoded_json_hack)
		 
		    @instance = JSON.parse(json_str)

	 	rescue Exception => e
 			return false
 		end
	    
	    return true
	end
end


