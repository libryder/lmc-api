class Comment < ActiveRecord::Base

  def as_json(*args)

    allowed_parameters = {
      "id"  => "id",
      "comment"  =>  "comment",
      "call_detail_id" => "call_detail_id",
      "created" =>  "created",
      "status" =>  "status",
      "user_id" => "user_id"
    } 

    Hash[super(*args).map { |k, v| 
      unless allowed_parameters[k].blank?
        [allowed_parameters[k], v]
      end
    }]
    
  end  

  def ouid
    call_detail = CallDetail.find self.call_detail_id
    call_detail.organizational_unit_id
  end

end
