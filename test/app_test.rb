require './test/test_helper.rb'
require './app'
require 'timecop'

class MyAppTest < Test::Unit::TestCase
  include Capybara::DSL

  def setup
    super
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
    request_offers

    assert page.has_content? INDEX_TITLE
    assert page.has_content? "The parameter 'uid' is required"
  end

  def test_request_mobile_offers_with_all_parameters_filled_in_renders_the_offers
    stub_mobile_offers_request(MOBILE_OFFERS, 200)

    visit_index
    fill_in_form_and_request_offers

    assert page.has_content? INDEX_TITLE
    assert page.has_selector? 'table.mobile_offers'
    assert page.has_content? 'Title'
    assert page.has_content? 'Thumbnail low resolution url'
    assert page.has_content? 'Payout'
    assert page.has_content? MOBILE_OFFERS[:offers][0][:title]
    assert page.has_content? MOBILE_OFFERS[:offers][0][:thumbnail][:lowres]
    assert page.has_content? MOBILE_OFFERS[:offers][0][:payout]
    assert page.has_content? MOBILE_OFFERS[:offers][1][:title]
    assert page.has_content? MOBILE_OFFERS[:offers][1][:thumbnail][:lowres]
    assert page.has_content? MOBILE_OFFERS[:offers][1][:payout]
  end

  def test_request_mobile_offers_and_no_offers_available_renders_a_blanc_slate
    stub_mobile_offers_request(NO_MOBILE_OFFERS, 200)

    visit_index
    fill_in_form_and_request_offers


    assert page.has_content? INDEX_TITLE
    assert page.has_content? 'No offers available'
  end

  def test_request_mobile_offers_which_results_in_an_error
    stub_mobile_offers_request(API_ERROR, 400)

    visit_index
    fill_in_form_and_request_offers

    assert page.has_content? INDEX_TITLE
    assert page.has_content? '400'
    assert page.has_content? API_ERROR[:code]
  end

  private

  def visit_index
    visit '/'
  end

  def fill_in_form_and_request_offers
    fill_in 'uid', :with => 'player1'
    fill_in 'pub0', :with => 'campaign2'
    fill_in 'page', :with => '1'
    request_offers
  end

  def request_offers
    click_on 'Request'
  end
end
