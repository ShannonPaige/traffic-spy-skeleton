require_relative '../test_helper'
class PayloadTest < FeatureTest

  def test_that_payloads_can_sort
    hash = {"http://jumpstartlab.com/page"=>1, "http://test_company_1.com/blog"=>3, "http://test_company_1.com/page"=>2}
    sorted = Payload.sort(hash)
    assert_equal [["http://test_company_1.com/blog", 3], ["http://test_company_1.com/page", 2], ["http://jumpstartlab.com/page", 1]], sorted
  end

  def test_that_payloads_can_count_pages
    array = ["http://test_company_1.com/blog", "http://test_company_1.com/page", "http://test_company_1.com/page"]
    number_of_items = Payload.count_items(array)
    expected = {"http://test_company_1.com/blog"=>1, "http://test_company_1.com/page"=>2}
    assert_equal expected , number_of_items
  end

  def test_payloads_can_find_event_names
    create_payloads_three

    data = Payload.find_one("test_company_1",:eventName)

    assert_equal [["socialLogin", 2], ["beginRegistration", 1]], data
  end

  def test_payloads_can_find_and_sort_resolutions_with_find_two
    create_payloads_three
    data = Payload.find_two("test_company_1",:resolutionWidth,:resolutionHeight )

    assert_equal [[["1920", "1280"], 2], [["2048", "1536"], 1]] , data

  end

  def test_payloads_creates_a_url_path
    create_payloads_three
     data = Payload.url_path("test_company_1", "http://test_company_1.com/page")
    assert_equal "/page", data
  end

  def test_payloads_creates_a_url_link
    create_payloads_three
    data = Payload.url_link('test_company_1',["http://test_company_1.com/page", 2])

    assert_equal "/sources/test_company_1/urls/page", data
  end

  def test_that_payload_can_create_an_event_link
    create_payloads_three
    data = Payload.event_link("test_company_1",["socialLogin", 2])
    assert_equal "/sources/test_company_1/events/socialLogin" , data
  end

  def test_payload_can_give_you_user_agent_data_browser
    create_payloads_three
    data = Payload.active_record_browser("test_company_1",:userAgent)
    assert_equal [["Chrome", 2], ["Firefox", 1]] , data
  end

  def test_payload_can_give_you_user_agent_data_os
    create_payloads_three
    data = Payload.active_record_os("test_company_1", :userAgent)
    assert_equal [["Macintosh", 2], ["Windows", 1]], data

  end

   def test_payload_can_give_you_an_hourly_breakdown_of_requested_information_times
     create_payloads_three
     data = Payload.hourly_breakdown('test_company_1')
     expected = {"12am - 1am"=>0, "1am - 2am"=>0, "2am - 3am"=>0, "3am - 4am"=>0, "4am - 5am"=>3, "5am - 6am"=>0, "6am - 7am"=>0, "7am - 8am"=>0, "8am - 9am"=>0, "9am - 10am"=>0, "10am - 11am"=>0, "11am - 12pm"=>0, "12pm to 1am"=>0, "1pm - 2pm"=>0,
       "2pm - 3pm"=>0, "3pm - 4pm"=>0, "4pm - 5pm"=>0, "5pm - 6pm"=>0, "6pm - 7pm"=>0, "7pm - 8pm"=>0, "8pm - 9pm"=>0, "9pm - 10pm"=>0, "10pm - 11pm"=>0, "11pm - 12am"=>0}

     assert_equal expected, data
  end
end
