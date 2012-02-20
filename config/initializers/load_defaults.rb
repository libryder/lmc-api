require 'yaml'

ALLOWED_PARAMS = HashWithIndifferentAccess.new(YAML::load(File.open("#{Rails.root}/config/allowed_parameters.yml")))
