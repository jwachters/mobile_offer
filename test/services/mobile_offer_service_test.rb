require './test/test_helper.rb'
require './services/mobile_offer_service'

class MobileOfferServiceTest < Test::Unit::TestCase
  def test_get_response_with_valid_params_returns_offers_and_status_200
    stub_mobile_offers_request(MOBILE_OFFERS, 200)

    service = MobileOfferService.new({ uid: 'player1', pub0: 'campaign2', page: '1' })

    assert_equal service.response_as_json['code'], MOBILE_OFFERS[:code]
    assert_equal service.status, '200'
  end

  def test_get_response_with_empty_user_values_returns_offers_and_status_200
    stub_mobile_offers_request(MOBILE_OFFERS, 200, test_params_with_empty_page)

    service = MobileOfferService.new({ uid: 'player1', pub0: 'campaign2', page: '' })

    assert_equal service.response_as_json['code'], MOBILE_OFFERS[:code]
    assert_equal service.status, '200'
  end

  def test_get_response_with_user_value_nil_returns_offers_and_status_200
    stub_mobile_offers_request(MOBILE_OFFERS, 200, test_params_with_empty_page)

    service = MobileOfferService.new({ uid: 'player1', pub0: 'campaign2' })

    assert_equal service.response_as_json['code'], MOBILE_OFFERS[:code]
    assert_equal service.status, '200'
  end

  def test_get_response_which_fails_and_returns_status_400
    stub_mobile_offers_request(API_ERROR, 400)

    service = MobileOfferService.new({ uid: 'player1', pub0: 'campaign2', page: '1' })

    assert_equal service.response_as_json['code'], API_ERROR[:code]
    assert_equal service.status, '400'
  end
end