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
    expected = {"url"=>"http://jumpstartlab.com/blog", "requestedAt"=>"2013-02-16 21:38:28 -0700", "respondedIn"=>37, "referredBy"=>"http://jumpstartlab.com", "requestType"=>"GET", "eventName"=>"socialLogin", "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17", "resolutionWidth"=>"1920", "resolutionHeight"=>"1280", "ip"=>"63.29.38.211", "sha"=>"394bf0a8e80605f0310046b5cb21ad878cbb5bcb06a969498f1ade76a9772fc8",
    "user_id"=>"jumpstartlab"}

    assert_equal expected, ParsePayload.parse(params)
 end
end
