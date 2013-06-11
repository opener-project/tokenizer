require 'sinatra/base'
require 'httpclient'

module Opener
  class Tokenizer
    ##
    # Language tokenizer server powered by Sinatra.
    #
    class Server < Sinatra::Base
      configure do
        enable :logging
      end

      configure :development do
        set :raise_errors, true
        set :dump_errors, true
      end

      ##
      # Provides a page where you see a textfield and you can post stuff
      #
      get '/' do
        erb :index
      end

      ##
      # Identifies a given text.
      #
      # @param [Hash] params The POST parameters.
      #
      # @option params [String] :text The text to tokenize.
      # @option params [TrueClass|FalseClass] :kaf Whether or not the input is in KAF format.
      # @option params [String] :language The language of the text. If :kaf option is selected, the language will be taken from the KAF file.
      # @option params [Array<String>] :callbacks A collection of callback URLs
      #  that act as a chain. The results are posted to the first URL which is
      #  then shifted of the list.
      # @option params [String] :error_callback Callback URL to send errors to
      #  when using the asynchronous setup.
      #
      post '/' do
        if !params[:text] or params[:text].strip.empty?
          logger.error('Failed to process the request: no text specified')

          halt(400, 'No text specified')
        end

        if params[:callbacks] and !params[:callbacks].strip.empty?
          process_async
        else
          process_sync
        end
      end

      private

      ##
      # Processes the request synchronously.
      #
      def process_sync
        output = tokenize_text(params[:text])

        content_type(:xml) if params[:kaf]

        body(output)
      rescue => error
        logger.error("Failed to tokenize the text: #{error.inspect}")

        halt(500, error.message)
      end

      ##
      # Processes the request asynchronously.
      #
      def process_async
        callbacks = params[:callbacks]
        callbacks = [callbacks] unless callbacks.is_a?(Array)

        Thread.new do
          tokenize_async(params[:text], callbacks, params[:error_callback])
        end

        status(202)
      end

      ##
      # @param [String] text The text to tokenize.
      # @return [String]
      # @raise RuntimeError Raised when the language identification process
      #  failed.
      #
      def tokenize_text(text)
        tokenizer             = Tokenizer.new(options_from_params)
        output, error, status = tokenizer.run(text)

        raise(error) unless status.success?

        return output
      end

      ##
      # Returns a Hash containing various GET/POST parameters extracted from
      # the `params` Hash.
      #
      # @return [Hash]
      #
      def options_from_params
        options = {}

        [:kaf, :language, :callback].each do |key|
          options[key] = params[key]
        end

        return options
      end

      ##
      # Identifies the text and submits it to a callback URL.
      #
      # @param [String] text
      # @param [Array] callbacks
      # @param [String] error_callback
      #
      def tokenize_async(text, callbacks, error_callback = nil)
        begin
          language = tokenize_text(text)
        rescue => error
          logger.error("Failed to tokenize the text: #{error.message}")

          submit_error(error_callback, error.message) if error_callback

          return
        end

        url = callbacks.shift

        logger.info("Submitting results to #{url}")

        begin
          process_callback(url, language, callbacks)
        rescue => error
          logger.error("Failed to submit the results: #{error.inspect}")

          submit_error(error_callback, error.message) if error_callback
        end
      end

      ##
      # @param [String] url
      # @param [String] language
      # @param [Array] callbacks
      #
      def process_callback(url, language, callbacks)
        HTTPClient.post(
          url,
          :body => {:language => language, :callbacks => callbacks}
        )
      end

      ##
      # @param [String] url
      # @param [String] message
      #
      def submit_error(url, message)
        HTTPClient.post(url, :body => {:error => message})
      end
    end # Server
  end # LanguageIdentifier
end # Opener
