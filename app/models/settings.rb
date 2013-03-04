class Settings < ActiveRecord::Base
  self.primary_key = 'key'
  
  attr_accessible :key, :value
  
  def self.find_or_create_default(key)
    begin
      settings = Settings.find(key)
    rescue ActiveRecord::RecordNotFound, Exception => e
	    settings = Settings.new(:key => '', :value => '{}')
    end

    return settings
  end

  def self.update(key,value)
    settings = Settings.find_or_create_default(key)
    
    settings.key = key
    settings.value = value
    settings.save()
  end
end
