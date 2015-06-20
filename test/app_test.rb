ENV['RACK_ENV'] = 'test'

require './app'
require 'capybara'
require 'capybara/dsl'
require 'test/unit'
require 'webmock/test_unit'
require 'json'

class MyAppTest < Test::Unit::TestCase
  include Capybara::DSL

  INDEX_TITLE = 'Mobile offers'
  API_URI = "http://api.sponsorpay.com/feed/v1/offers.json"
  NO_CONTENT = {code: 'NO_CONTENT'}.to_json
  OFFERS = {code: 'OK'}.to_json

  def setup
    Capybara.app = MobileOfferApp
  end

  def test_visit_index_returns_a_title
    visit_index
    assert page.has_content? INDEX_TITLE
  end

  def test_visit_index_returns_a_form_to_get_mobile_offers
    visit_index
    assert page.has_selector? 'form[action="/mobile_offers"]'
    assert page.has_selector? 'input[type="text"][name="uid"]'
    assert page.has_selector? 'input[type="text"][name="pub0"]'
    assert page.has_selector? 'input[type="text"][name="page"]'
    assert page.has_selector? 'button[type="submit"]'
  end

  def test_request_mobile_offers_without_parameters_to_get_mobile_offers
    visit_index
    click_on 'Request'

    assert page.has_content? INDEX_TITLE
    assert page.has_content? "The parameter 'uid' is required"
  end

  def test_request_mobile_offers_with_all_parameters_filled_in_renders_the_offers
    stub_offers_request_and_return(OFFERS)

    visit_index
    fill_in_request_form
    click_on 'Request'

    assert page.has_content? INDEX_TITLE
    assert page.has_selector? 'table.offers'
    assert page.has_content? 'Title'
    assert page.has_content? 'Thumbnail lowres'
    assert page.has_content? 'Payout'
  end

  def test_request_mobile_offers_and_no_offers_available_renders_a_blanck_slate
    stub_offers_request_and_return(NO_CONTENT)

    visit_index
    fill_in_request_form
    click_on 'Request'

    assert page.has_content? INDEX_TITLE
    assert page.has_content? 'No offers available'
  end

  private

  def visit_index
    visit '/'
  end

  def fill_in_request_form
    fill_in 'uid', :with => 'player1'
    fill_in 'pub0', :with => 'campaign2'
    fill_in 'page', :with => '1'
  end

  def stub_offers_request_and_return(response)
    stub_request(:get, API_URI).to_return(body: response)
  end
end