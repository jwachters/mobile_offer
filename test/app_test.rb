require './app'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    MobileOfferApp
  end

  def test_get_index_returns_mobile_offer
    get '/'
    assert last_response.ok?
    assert_equal 'Mobile offer', last_response.body
  end
end