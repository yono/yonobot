require 'sqlite3'
require 'mongo'

create_sql = <<SQL
CREATE TABLE prefix_words (
  id integer PRIMARY KEY AUTOINCREMENT,
  word1 string,
  word2 string);
SQL

create_sql2 = <<SQL
CREATE TABLE suffix_words (
  id integer PRIMARY KEY AUTOINCREMENT,
  prefix_id integer,
  word string);
SQL

db = SQLite3::Database.new("markovchaings.db")
db.execute(create_sql)
db.execute(create_sql2)

uri = 'xxx'
client = Mongo::Client.new(uri)

collection = client[:markovchains]

nodes = collection.find

nodes.each do |node|
  prefix = node['prefix']
  suffix = node['suffix']

  puts "prefix: #{prefix}"

  db.execute("INSERT INTO prefix_words(word1, word2) VALUES (?, ?);", prefix[0], prefix[1])
  id = db.execute("SELECT id FROM prefix_words WHERE id = last_insert_rowid();")[0][0]
  puts "id: #{id}"
  suffix.each do |word|
    puts "suffix: #{word}"
    db.execute("INSERT INTO suffix_words(prefix_id, word) VALUES (?, ?);", id, word)
  end
end
