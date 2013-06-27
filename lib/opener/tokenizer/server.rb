require 'sinatra/base'
require 'httpclient'
require 'opener/webservice'

module Opener
  class Tokenizer
    ##
    # Text tokenizer server powered by Sinatra.
    #
    class Server < Webservice
      set :views, File.expand_path('../views', __FILE__)
      text_processor Tokenizer
      accepted_params :input, :kaf, :language
    end # Server
  end # Tokenizer
end # Opener
