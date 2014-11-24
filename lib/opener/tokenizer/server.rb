require 'opener/webservice'

module Opener
  class Tokenizer
    ##
    # Text tokenizer server powered by Sinatra.
    #
    class Server < Webservice::Server
      set :views, File.expand_path('../views', __FILE__)

      self.text_processor  = Tokenizer
      self.accepted_params = [:input, :kaf, :language]
    end # Server
  end # Tokenizer
end # Opener
