ENV['RACK_ENV'] = 'test'

require './app'
require 'capybara'
require 'capybara/dsl'
require 'test/unit'


class MyAppTest < Test::Unit::TestCase
  include Capybara::DSL

  INDEX_TITLE = 'Mobile offer'

  def setup
    Capybara.app = MobileOfferApp
  end

  def test_visit_index_returns_a_title
    visit '/'
    assert page.has_content? INDEX_TITLE
  end

  def test_visit_index_returns_a_form_to_get_mobile_offers
    visit '/'
    assert page.has_selector? 'form[action="/mobile_offers"]'
    assert page.has_selector? 'input[type="text"][name="uid"]'
    assert page.has_selector? 'input[type="text"][name="pub0"]'
    assert page.has_selector? 'input[type="text"][name="page"]'
    assert page.has_selector? 'button[type="submit"]'
  end

  def test_request_mobile_offers_without_parameters_to_get_mobile_offers
    visit '/'
    click_on 'Request'

    assert page.has_content? INDEX_TITLE
    assert page.has_content? "The parameter 'uid' is required"
  end

  def test_request_mobile_offers_with_all_parameters_filled_in
    visit '/'
    fill_in 'uid', :with => 'player1'
    fill_in 'pub0', :with => 'campaign2'
    fill_in 'page', :with => '1'
    click_on 'Request'

    assert page.has_content? INDEX_TITLE
    assert page.has_selector? 'table.offers'
    assert page.has_content? 'Title'
    assert page.has_content? 'Thumbnail lowres'
    assert page.has_content? 'Payout'
  end
end