require 'sinatra'

class MobileOfferApp < Sinatra::Base
  get '/' do
    render_index
  end

  get '/mobile_offers' do
    if params[:uid].empty?
      @request_invalid = true
      render_index
    else
      @request_successful = true
      render_offers(get_offers)
    end
  end

  private

  def render_index
    erb :index
  end

  def render_offers(response)
    case response['code']
      when 'NO_CONTENT'
        render_index_with_partial(:no_content)
      when 'OK'
        render_index_with_partial(:offers)
    end
  end

  def render_index_with_partial(partial)
    erb partial, layout: :index
  end

  def get_offers
    uri = URI('http://api.sponsorpay.com/feed/v1/offers.json')
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end