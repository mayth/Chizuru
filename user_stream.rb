require 'oauth'
require 'yaml'
require 'yajl'

module Chizuru
  class UserStream
    DEFAULT_USER_AGENT = 'TwitterBot/1.0 (Based on Chizuru)'

    def initialize(credential_path, screen_name, ca_file_path, user_agent = DEFAULT_USER_AGENT)
      raise ArgumentError unless credential_path
      cred = YAML.load_file(credential_path)
      consumer = OAuth::Consumer.new(cred['consumer_key'], cred['consumer_secret'])
      @credential = {
        consumer: consumer,
        access_token: OAuth::AccessToken.new(
          consumer,
          cred['access_token'],
          cred['access_token_secret'])
      }
      raise ArgumentError unless screen_name
      @screen_name = screen_name
      raise ArgumentError unless ca_file_path
      @ca_file = ca_file_path
      @user_agent = user_agent
    end

    def connect
      uri = URI.parse("https://userstream.twitter.com/2/user.json?track=#{@screen_name}")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.ca_file = @ca_file
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5

      https.start do |https|
        request = Net::HTTP::Get.new(uri.request_uri,
                                     "User-Agent" => @user_agent,
                                     "Accept-Encoding" => "identity")
        request.oauth!(https, @credential[:consumer], @credential[:access_token])

        buf = ""
        puts 'starting request'
        https.request(request) do |response|
          puts 'request ok'
          response.read_body do |chunk|
            puts 'reading http body (chunk)'
            buf << chunk
            while ((line = buf[/.+?(\r\n)+/m]) != nil)
              puts 'line'
              begin
                buf.sub!(line, "")
                line.strip!
                status = Yajl::Parser.parse(line)
              rescue
                break
              end

              yield status
            end
          end
        end
      end
    end
  end
end
