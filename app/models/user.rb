class User < ActiveRecord::Base

  def as_json(*args)

    allowed_parameters = {
      "id"  =>  "id",
      "username"  =>  "email",
      "created" => "created",
      "first_name" =>  "first_name",
      "last_name" =>  "last_name",
      "organizational_unit_id" =>  "ouid",
      "status"    =>  "status",
      "external_id" =>  "external_id",
      "group_id" =>  "group_id"
    } 

    Hash[super(*args).map { |k, v| 
      if k.to_s == 'external_id' && !v.blank?
       v = v.split('|')[1]
      end
      unless allowed_parameters[k].blank?
        [allowed_parameters[k], v]
      end
    }]
    
  end  

end
