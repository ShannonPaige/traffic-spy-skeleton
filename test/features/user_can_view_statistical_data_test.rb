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
save_and_open_page
    assert page.has_content?("Average response time")
    within("#avg_response li:first") do
      assert page.has_content?(36)
    end

    # assert page.has_content?("HTTP verbs")
    # assert page.has_content?("Referrrers")
    # assert page.has_content?("User agents")
  end

  def test_if_identifier_relative_or_path_is_missing_it_redirects_to_error_page
    skip
    create_user(1)

    visit ('/sources/IDENTIFIER/urls/RELATIVE/PATH')

    assert_equal '/sources/IDENTIFIER/urls/RELATIVE/PATH', current_path

    refute page.has_content?("Longest response time")
    refute page.has_content?("Shortest response time")
    refute page.has_content?("Average response time")
    refute page.has_content?("HTTP verbs")
    refute page.has_content?("Referrrers")
    refute page.has_content?("User agents")
  end


end
