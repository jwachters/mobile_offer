require 'sinatra'

class MobileOfferApp < Sinatra::Base
  get '/' do
    erb :index
  end
end