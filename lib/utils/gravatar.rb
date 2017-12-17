require 'net/http'
require 'digest/md5'

module Utils
  module Gravatar
    extend self

    def exists?(email, options = {})
      options = { :rating => 'x', :timeout => 2 }.merge(options)
      http = Net::HTTP.new('www.gravatar.com', 80)
      http.read_timeout = options[:timeout]
      response = http.request_head("/avatar/#{hash(email)}?rating=#{options[:rating]}&default=http://gravatar.com/avatar")
      response.code != '302'
    rescue StandardError, Timeout::Error
      false
    end

    def url(email, options = {})
      options = { size: 32 }.merge(options)

      "https://www.gravatar.com/avatar/#{hash(email)}?s=#{options[:size]}&default=#{options[:default]}"
    end

    private

      def hash(email)
        Digest::MD5.hexdigest(email.to_s.downcase)
      end
  end
end
