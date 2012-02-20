class ChargifyProduct < ActiveRecord::Base
  def as_json(*args)
    #*args.delete :created_at
    allowed_parameters = {
      "name"  =>  "subscription_name",
      "renewal" => "renewal_period"
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
