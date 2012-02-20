class CallDetail < ActiveRecord::Base

  def as_json(*args)

    allowed_parameters = {
      "id"  => "id",
      "organizational_unit_id"  =>  "ouid",
      "user_id"  =>  "user_id",
      "start_date" => "calldate",
      "destination" =>  "tracking_number",
      "target_number" =>  "ringto_number",
      "source" =>  "caller_id",
      "is_outbound" =>  "is_outbound",
      "duration"  =>  "duration",
      "monitored_file_name"  =>  "file_url",
      "status"    =>  "status",
      "external_id" =>  "external_id"
    } 

    Hash[super(*args).map { |k, v| 
      unless v.blank?
      if k.to_s == 'external_id'
       v = v.split('|')[1]
      elsif k.to_s == 'start_date'
        v = Time.parse(v.to_s).strftime("%Y-%m-%d %H:%M:%S").to_s
      elsif k.to_s == "monitored_file_name"
        v = "http://app.logmycalls.com/download/audio/#{id}"
      end
      end
      unless allowed_parameters[k].blank?
        [allowed_parameters[k], v]
      end
    }]
    
  end  

  
end
