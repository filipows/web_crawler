#!/bin/env ruby
# encoding: utf-8

require_relative 'helpers/synonyms'
require_relative 'link_properties'
require 'nokogiri'


AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'


#a =  Synonyms::get_synonyms('charakteryzować się')
#puts a
#puts a.length


def internal? (url)
  url =~ /^\//
end



url = 'http://www.loswiaheros.pl/kalendarz'

doc = Nokogiri::HTML(open (url)   , "User-Agent" => AGENT)
uri = URI url


internal_links = {}
external_links = {}
doc.xpath('//a[@href]').each do |link|

  if internal? link['href']
    full_link =  "#{uri.scheme}://#{uri.host}#{link['href']}"
    internal_links[link.text.strip] = full_link
  else
    external_links[link.text.strip] = link['href']
  end
end

puts "Internals #{internal_links}"
puts "Externals #{external_links}"





