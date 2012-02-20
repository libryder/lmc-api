class CakeSession < ActiveRecord::Base
  attr_accessible :id, :data, :expires
end
