ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/dsl'
require 'test/unit'
require 'webmock/test_unit'
require 'json'

WebMock.disable_net_connect!(allow_localhost: true)

class Test::Unit::TestCase
  INDEX_TITLE = 'Mobile offers'
  API_URI = 'http://api.sponsorpay.com/feed/v1/offers.json'

  MOBILE_OFFERS = { code: 'OK', offers: [{ title: 'Telekom Bargeld', thumbnail: { lowres: 'http://cdn2.sponsorpay.com/assets/51389/telekom175x175_(1)_mobile_square_60.jpg' }, payout: '72252' },
                                         { title: 'Cinematrix - HD Movies', thumbnail: { lowres: 'http://cdn1.sponsorpay.com/assets/50031/Cinematrix_square_60.jpg' }, payout: '277563' }]}
  NO_MOBILE_OFFERS = { code: 'NO_CONTENT' }
  API_ERROR = { code: 'ERROR_INVALID_UID' }

  def setup
    Timecop.freeze(Time.new(2015, 1, 30))
  end

  def teardown
    Timecop.return
    WebMock.reset!
  end

  private

  def stub_mobile_offers_request(response, status, params = test_params)
    stub_request(:get, API_URI + "?#{URI.encode_www_form(params)}")
      .with( headers: { 'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.sponsorpay.com', 'User-Agent'=>'Ruby' })
      .to_return(body: response.to_json, status: status)
  end

  def test_params
    {
      appid: 157,
      device_id: '2b6f0cc904d137be2e1730235f5664094b83',
      hashkey: 'e33c12c885434a772a37b0828d618b51019affe0',
      ip: '109.235.143.113',
      locale: 'de',
      offer_types: 112,
      page: 1,
      pub0: 'campaign2',
      timestamp: Time.now.to_i,
      uid: 'player1'
    }
  end

  def test_params_with_empty_page
    {
      appid: 157,
      device_id: '2b6f0cc904d137be2e1730235f5664094b83',
      hashkey: '3fa7f60eceae7172cfda52ba2787d4342b5fa04d',
      ip: '109.235.143.113',
      locale: 'de',
      offer_types: 112,
      pub0: 'campaign2',
      timestamp: Time.now.to_i,
      uid: 'player1'
    }
  end
end