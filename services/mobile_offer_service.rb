require 'digest/sha1'
require 'json'

class MobileOfferService
  API_URI = 'http://api.sponsorpay.com/feed/v1/offers.json'

  def initialize(user_params)
    @user_params = user_params.reject { |_, value| value.nil? || value.empty? }
    uri = URI(API_URI)
    uri.query = encoded_params(all_params_with_hash_key)
    @response = Net::HTTP.get_response(uri)
  end

  def response_as_json
    JSON.parse(@response.body)
  end

  def status
    @response.code
  end

  private

  def all_params_with_hash_key
    all_params.merge(hashkey: hash_key)
  end

  def all_params
    @all_params ||= base_params.merge(@user_params)
  end

  def base_params
    {
      appid: 157,
      device_id: '2b6f0cc904d137be2e1730235f5664094b83',
      locale: 'de',
      ip: '109.235.143.113',
      offer_types: 112,
      timestamp: Time.now.to_i
    }
  end

  def hash_key
    Digest::SHA1.hexdigest("#{encoded_params(all_params.sort)}&#{ENV['API_KEY']}")
  end

  def encoded_params(params)
    URI.encode_www_form(params)
  end
end