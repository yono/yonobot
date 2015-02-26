#!/usr/bin/env ruby
# -*- coding:utf-8 -*-

require 'csv'
require 'uri'
require 'cgi'
require 'natto'
require 'twitter'
require 'mongo'

NONWORD = "\n"
#START_SENTENCE = [NONWORD, NONWORD]
#END_SENTENCE = NONWORD

nm = Natto::MeCab.new(userdic: '../custom.dic')

table = CSV.table('tweets.csv', headers: true, header_converters: :symbol)

count = 0
h = {}
table.each do |row|
  next if row[:text].is_a?(Fixnum)

  #####
  # validation
  #####
  # URL 入ってたらダメ
  have_url = URI.regexp =~ row[:text]

  # 「」が含まれたらダメ
  have_kagi = /「|」/ =~ row[:text]

  # ()（）が含まれたらダメ
  have_kakko = /\(|\)|（|）/ =~ row[:text]

  result = !have_url && !have_kagi && !have_kakko ? '◯' : '×'
  count = count + 1 if result == '◯'

  #####
  # データを綺麗にする
  #####
  text = row[:text].gsub(/\*tp/, "")
  text = text.gsub(/\*p/, "")
  text = text.gsub(/\*Tw\*/, "")
  # @username は消す
  text = text.gsub(/@[^\s]+/, "")
  # #hashtag は消す
  text = text.gsub(/#[^\s]+/, "")
  text = text.gsub(/\n/, "")
  text = CGI.unescapeHTML(text)
  text = text.strip

  puts "#{count}/#{table.size}"
  puts "#{result} #{text}"
  if result == '◯'
    surfaces = [NONWORD, NONWORD]
    nm.parse(text) do |n|
      surfaces << n.surface
    end
    surfaces << NONWORD

    # データ突っ込む
    surfaces.each_cons(3).each do |pre_suf|
      suffix = pre_suf.pop
      prefix = pre_suf

      h[prefix] ||= []
      h[prefix] << suffix
    end
  end
end

connection = Mongo::Connection.new
db = connection.db('twitter')
coll = db.collection('malcovchains')
h.each do |key, value|
  doc = {prefix: key, suffix: value}
  coll.insert(doc)
end
