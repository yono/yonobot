require 'mongo'
require 'dotenv'
Dotenv.load

module Yonobot
  class MongoDB
    def initialize
      db = nil
      if ENV['MONGOLAB_URI']
        uri = ENV['MONGOLAB_URI']
        connection = Mongo::Connection.from_uri(uri)
        db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
        db = connection.db(db_name)
      else
        connection = Mongo::Connection.new
        db = connection.db('twitter')
      end
      puts db
      @coll = db.collection('markovchains')
    end

    def coll
      @coll
    end
  end
end
