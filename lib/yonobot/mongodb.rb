require 'mongo'
require 'dotenv'
Dotenv.load

module Yonobot
  class MongoDB
    def collection
      return @collection if defined?(@collection)

      @collection = client[:markovchains]
    end

    private

    def dbname_from_uri(uri)
      # Extract from mongodb URI Schema
      # Schmea => mongodb://USERNAME:PASSWORD@HOSTNAE:PORT/DBNAME
      uri[%r{/([^/\?]+)(\?|$)}, 1]
    end

    def uri
      ENV['DB_URI']
    end

    def client
      return @client if defined?(@client)

      if uri
        @client = Mongo::Client.new(uri)
      else
        @client = Mongo::Client.new(["mongo:27017"], database: 'twitter')
      end
      @client
    end
  end
end
