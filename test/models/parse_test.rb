require_relative '../test_helper'

class ParsePayloadTest < FeatureTest #Minitest::Test

  def test_parse_method_returns_info_from_json_string
    params = {"payload"=>
               "{\"url\":\"http://jumpstartlab.com/blog\",\n
                 \"requestedAt\":\"2013-02-16 21:38:28 -0700\",\n
                 \"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\n
                 \"requestType\":\"GET\",\n
                 \"parameters\":[],\n
                 \"eventName\": \"socialLogin\",\n
                 \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\n
                 \"resolutionWidth\":\"1920\",\n
                 \"resolutionHeight\":\"1280\",\n
                 \"ip\":\"63.29.38.211\"}", "splat"=>[], "captures"=>["jumpstartlab"],"identifier"=>"jumpstartlab"}

    stuff = ParsePayload.parse(params)
    expected = {"url"=>"http://jumpstartlab.com/blog", "requestedAt"=>"2013-02-16 21:38:28 -0700", "respondedIn"=>37, "referredBy"=>"http://jumpstartlab.com", "requestType"=>"GET", "parameters"=>[], "eventName"=>"socialLogin", "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth"=>"1920", "resolutionHeight"=>"1280", "ip"=>"63.29.38.211"}
    assert_equal expected, stuff
  end

end
