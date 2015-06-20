require 'sinatra'

class MobileOfferApp < Sinatra::Base
  get '/' do
    render_index
  end

  get '/mobile_offers' do
    if !params[:uid].empty?
      @request_successful = true
    else
      @request_invalid = true
    end
    render_index
  end

  private

  def render_index
    erb :index
  end
end