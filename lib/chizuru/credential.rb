require 'yaml'

module Chizuru
  # Represents credentials.
  class Credential
    # Gets the consumer.
    attr_reader :consumer
    # Gets the access token.
    attr_reader :access_token

    # Initializes the credentials from the given file.
    #
    # The file must be YAML file, and it must have these keys: `consumer_key`, `consumer_secret`, `access_token`, and `access_token_secret`.
    def initialize(path)
      cred = YAML.load_file(path)
      @consumer = OAuth::Consumer.new(
        cred['consumer_key'],
        cred['consumer_secret'],
        site: 'https://api.twitter.com/1.1')
      @access_token =  OAuth::AccessToken.new(
          consumer,
          cred['access_token'],
          cred['access_token_secret'])
    end
  end
end
