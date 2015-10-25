require_relative '../test_helper'

class ApplicationEventDetailsTest < FeatureTest

  def test_user_can_see_an_hourly_breakdown_of_when_events_were_recieved
    create_user(1)
    create_payloads_five

    visit "/sources/test_company_1/events/socialLogin"

    assert_equal "/sources/test_company_1/events/socialLogin", current_path
 # save_and_open_page
    assert page.has_content?("Hourly Breakdown")
    within("#event_details li:first") do
      assert page.has_content?("12am - 1am")
      assert page.has_content?(1)
    end
    within("#event_details li:last") do
      assert page.has_content?("11pm - 12am")
      assert page.has_content?(1)
    end
  end

  def test_user_can_see_how_many_events_there_were
    create_user(1)
    create_payloads_five

    visit "/sources/test_company_1/events/socialLogin"

    assert_equal "/sources/test_company_1/events/socialLogin", current_path
    # save_and_open_page
    assert page.has_content?("There were a total of")
    within("#event_total") do
      assert page.has_content?(4)
    end
  end


  def test_user_cant_see_thier_data_if_it_doesnt_exist_SAD
    create_user(1)
    Payload.create({url: "http://test_company_1.com/page",
                    requestedAt: "2013-02-16 21:38:28 -0700",
                    respondedIn: 45,
                    referredBy: "http://test_company_1.com",
                    requestType: "GET",
                    # eventName:  "",
                    userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                    resolutionWidth: "1920",
                    resolutionHeight: "1280",
                    sha: "12abedfog8erevdaddg",
                    user_id: "test_company_1",
                    ip: "63.29.38.211"})
    visit '/sources/test_company_1/events'

    assert_equal '/sources/error', current_path
    assert page.has_content?("Error: No given Event Name in payload")
  end

end
