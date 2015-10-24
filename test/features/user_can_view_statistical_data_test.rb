require './test/test_helper'

class UserGetsURLStatisticsTest <FeatureTest
  def test_registered_user_will_recieve_statistical_data
    create_user(1)
    create_payloads_three

    visit ('/sources/test_company_1/urls/blog')

    assert_equal '/sources/test_company_1/urls/blog', current_path

    assert page.has_content?("Longest response time")
    within("#long_response li:first") do
      assert page.has_content?(45)
    end

    assert page.has_content?("Shortest response time")
    within("#short_response li:first") do
      assert page.has_content?(27)
    end

    assert page.has_content?("Average response time")
    within("#avg_response li:first") do
      assert page.has_content?(36)
    end

    assert page.has_content?("HTTP verbs")
    within("#verbs li:first") do
      assert page.has_content?(2)
      assert page.has_content?("GET")
    end
    within("#verbs li:last") do
      assert page.has_content?(1)
      assert page.has_content?("POST")
    end

    assert page.has_content?("referrers")
    within("#referrers li:first") do
      assert page.has_content?(1)
      assert page.has_content?("http://yung-jhun.com")
    end
    within("#referrers li:last") do
      assert page.has_content?(1)
      assert page.has_content?("http://asap-edgar.com")
    end

    assert page.has_content?("user agents")
    within("#user_agent li:first") do
      assert page.has_content?(2)
      assert page.has_content?("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    end
    within("#user_agent li:last") do
      assert page.has_content?(1)
      assert page.has_content?("Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1")
    end
  end
end
