class OrganizationalUnit < ActiveRecord::Base
  acts_as_tree

  def as_json(*args)

    allowed_parameters = {
      "id"  =>  "ouid",
      "name" =>  "name",
      "address_line_1" =>  "address_line_1",
      "address_line_2" =>  "address_line_2",
      "city" =>  "city",
      "state" =>  "state",
      "zip"  =>  "zip",
      "is_store" => "is_store",
      "latitude" => "latitude",
      "longitude" => "longitude",
      "phone_number" => "phone_number",
      "status" => "status",
      "external_id" =>  "external_id"
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
