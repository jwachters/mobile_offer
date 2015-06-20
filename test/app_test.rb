require './app'
require 'test/unit'
require 'rack/test'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MobileOfferApp
  end

  def test_get_index_returns_a_title
    get '/'
    assert_includes last_response.body, '<h1>Mobile offer</h1>'
  end

  def test_get_index_returns_3_input_fields
    get '/'
    assert_includes last_response.body, '<input type="text" name="uid">'
    assert_includes last_response.body, '<input type="text" name="pub0">'
    assert_includes last_response.body, '<input type="text" name="page">'
  end
end