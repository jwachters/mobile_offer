require 'sinatra'
require './services/mobile_offer_service'

class MobileOfferApp < Sinatra::Base
  get '/' do
    render_index
  end

  get '/mobile_offers' do
    if params[:uid].empty?
      @request_invalid = true
      render_index
    else
      render_offers
    end
  end

  private

  def render_index
    erb :index
  end

  def render_offers
    @mobile_offer_service = MobileOfferService.new(permitted_params)
    @mobile_offers = @mobile_offer_service.response_as_json
    case @mobile_offers['code']
      when 'NO_CONTENT'
        render_index_with_partial(:no_content)
      when 'OK'
        render_index_with_partial(:mobile_offers)
      else
        render_index_with_partial(:api_error)
    end
  end

  def render_index_with_partial(partial)
    erb partial, layout: :index
  end

  def permitted_params
    { uid: params[:uid], pub0: params[:pub0], page: params[:page] }
  end
end