require './test/test_helper.rb'
require './app'
require 'rack/test'

class AppRequestTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MobileOfferApp
  end

  def test_get_mobile_offers_without_params_renders_message_uid_is_required
    get '/mobile_offers'

    assert last_response.ok?
    assert_includes last_response.body, "The parameter 'uid' is required"
  end
end