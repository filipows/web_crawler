#!/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'set'

class Synonyms
  AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'
  SYNONIMY_UX_PL_PATTERN = 'http://synonimy.ux.pl/multimatch.php?word='

  URL_ENCODING = {'ą' => '%B1',
                  'ć' => '%E6',
                  'ę' => '%EA',
                  'ł' => '%B3',
                  'ń' => '%F1',
                  'ó' => '%F3',
                  'ś' => '%B6',
                  'ż' => '%BF',
                  'ź' => '%BC',

                  'Ą' => '%A1',
                  'Ć' => '%C6',
                  'Ę' => '%CA',
                  'Ł' => '%A3',
                  'Ń' => '%D1',
                  'Ó' => '%D3',
                  'Ś' => '%A6',
                  'Ż' => '%AF',
                  'Ź' => '%AC',
                  ' ' => '+'  }

  def self.get_synonyms(word)
    word = encode_url(word)
    doc = Nokogiri::HTML(open (SYNONIMY_UX_PL_PATTERN + word)   , "User-Agent" => AGENT)
    word_table = extract_synonyms_from doc
    word_table.to_set.to_a         # return array of unique words
  end

  private
  def self.encode_url(text)
    text.gsub(/[ąćęłńóśżźĄĆĘŁŃÓŚŻŹ ]/, URL_ENCODING)
  end

  def self.extract_synonyms_from(doc)
    prepared_doc = Nokogiri::HTML(doc.css('.firstcompact+ .compact li').to_s.gsub(/<\/a><\/li>/, ','))
    word_table = prepared_doc.text.split(',')
    word_table.each do |w|
      w.strip!
    end
    word_table
  end
end