require 'sinatra'

class MobileOfferApp < Sinatra::Base
  get '/' do
    "Mobile offer"
  end
end