require 'yaml'

module Chizuru
  class Credential
    attr_reader :consumer, :access_token
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
