require './test/test_helper'

class ApplicationDetailTest < FeatureTest

  def test_user_can_see_thier_data_HAPPY
    create_user(1)
    create_payloads_three
    visit '/sources/test_company_1'

    assert_equal '/sources/test_company_1', current_path

    assert page.has_content?("Most Requested URLS")
    assert page.has_content?("Average Response Time")

    within("#urls") do
      assert page.has_content?(2)
      assert page.has_content?("http://test_company_1.com/page")
      assert page.has_content?(1)
      assert page.has_content?("http://test_company_1.com/blog")
      assert page.has_content?(36)
      assert page.has_content?(37)
    end

    assert page.has_content?("Screen Resolution")
    within("#screen_resolution") do
      assert page.has_content?(2)
      assert page.has_content?("1920 x 1280")
      assert page.has_content?(1)
      assert page.has_content?("2048 x 1536")
    end

    assert page.has_content?("Web Browser Breakdown")
    within("#browser_breakdown") do
      assert page.has_content?(2)
      assert page.has_content?("Chrome")
      assert page.has_content?(1)
      assert page.has_content?("Firefox")
    end

    assert page.has_content?("OS Breakdown")
    within("#os_breakdown") do
      assert page.has_content?("Macintosh")
      assert page.has_content?("Windows")
      assert page.has_content?(2)
    end
  end

  def test_user_can_click_on_urls_to_see_detailed_data
    create_user(1)
    create_payloads_three
    visit '/sources/test_company_1'

    assert_equal '/sources/test_company_1', current_path

    within('#urls') do
      click_link("http://test_company_1.com/page")
      assert_equal '/sources/test_company_1/urls/page', current_path
    end
  end

  def test_user_can_see_thier_data_SAD
    visit '/sources/test_company_1'

    assert_equal '/sources/error', current_path
    assert page.has_content?("Error: No user given.")
  end
end
