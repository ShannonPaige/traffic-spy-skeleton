require 'json'


class ParsePayload

  def self.parse(params)
    data = JSON.parse(params['payload'])
    data["sha"] = Digest::SHA2.hexdigest(params.to_s)
    data["user_id"] = params["identifier"]
    data.delete("parameters")
    data
  end

end
