class AppController < ActionController::Base

  before_filter :require_instance
  before_filter :get_request_key
  
  def widget
    value = Settings.find_or_create_by_key(@key).value || '{}'
    @settings = value.html_safe
  end
  
  def settings
    value = Settings.find_or_create_by_key(@key).value || '{}'
    @settings = value.html_safe
  end
  
  def settingsupdate
    @settings = Settings.find(@key)
    @settings.update_attributes(:value => params[:settings])
    
    render :json => {}, :status => 200
  end
  
  private

  def require_instance
    @instance = params[:parsed_instance]
  end
  
  def get_request_key
    @key = @instance['instance_id'] + ':'
    
    if (params[:origCompId])
      @key = @key + params[:origCompId]
    else
      @key = @key + params[:compId]
    end
    @key
  end
  
end


