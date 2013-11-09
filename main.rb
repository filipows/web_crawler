#!/bin/env ruby
# encoding: utf-8

require_relative 'helpers/synonyms'
require_relative 'link_properties'
require_relative 'link_extractor'
require 'nokogiri'

AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'
url = 'http://www.loswiaheros.pl/kalendarz'


doc = Nokogiri::HTML(open (url)   , "User-Agent" => AGENT)
uri = URI url
base_link = "#{uri.scheme}://#{uri.host}"

puts LinkExtractor::get_internal_links(doc, base_link)
puts LinkExtractor::get_external_links(doc)


