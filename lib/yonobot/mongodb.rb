require 'mongo'
require 'dotenv'
Dotenv.load

module Yonobot
  class MongoDB
    def initialize
      db = if uri
        connection = Mongo::Connection.from_uri(uri)
        connection.db(dbname_from_uri(uri))
      else
        connection = Mongo::Connection.new
        connection.db('twitter')
      end
      @collection = db.collection('markovchains')
    end

    def collection
      @collection
    end

    private

    def dbname_from_uri(uri)
      # Extract from mongodb URI Schema
      # Schmea => mongodb://USERNAME:PASSWORD@HOSTNAE:PORT/DBNAME
      uri[%r{/([^/\?]+)(\?|$)}, 1]
    end

    def uri
      ENV['MONGOLAB_URI']
    end
  end
end
