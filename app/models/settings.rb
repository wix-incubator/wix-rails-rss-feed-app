class Settings < ActiveRecord::Base
  self.primary_key = 'key'
  
  attr_accessible :key, :value
end
