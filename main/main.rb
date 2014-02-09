#!/bin/env ruby
# encoding: utf-8


require_relative 'helpers/synonyms'
require_relative 'link_extractor'
require_relative 'website_link'
require_relative 'evaluator'
require 'nokogiri'
require 'i18n'
require 'timeout'

AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'

#http://www.etools.ch/partnerSearch.do?partner=Test&query=wroclaw+gastronomia&?dataSourceResults=40
#url = 'http://localhost:8080/dcs/rest?dcs.source=etools&query=wroc%C5%82aw+gastronomia&results=200&dcs.algorithm=lingo&dcs.output.format=XML'


word_list = %w{wrocław gastronomia obiad obiadowe obiadami obiadowy śniadanie śniadania śniadaniowy kolacja kolacje jedzenie pizza}
#extended_word_list = Synonyms.get_extended_word_list(word_list)


#doc = Nokogiri::XML(open (url)   , "User-Agent" => AGENT)
#f = File.open("./sources/etoolsch_output.xml")
#doc = Nokogiri::XML(f)
#f.close
#urls = doc.xpath("//url")



def get_links_from_seed(doc)
  link_array = Array.new
  urls = doc.xpath("//url")

  urls.each do |url_node|
    newLink = WebsiteLink.new( url_node.text )
    link_array.push(newLink)
  end

  link_array
end


# Returns array of WebsiteLink's
def get_all_links_from_website( url, doc )  #parent evaluation?
  extracted_website_links = Array.new
  doc.xpath('//a[@href]').each do |link|
    begin
      new_link = WebsiteLink.new( URI.join(url, link['href']).to_s , link.text.strip )
      extracted_website_links.push( new_link )
    rescue Exception
    end
  end
  extracted_website_links
end





search_limit = 5000
threshold = 5

frontier = Array.new          #(array of WebsiteLinks)
visited_links = Set.new       #(set of raw urls)
found_links = Array.new       #(array of WebsiteLinks)
#BREADTH FIRST SEARCH
  # 1 LOAD SEED TO FRONTIER
    f = File.open("./sources/etoolsch_output.xml")
    doc = Nokogiri::XML(f)
    f.close
    frontier = get_links_from_seed(doc)

    #frontier.each do |frontier_link|
    #  puts frontier_link.value
    #end

  # 2 TAKE FIRST LINK FROM FRONTIER AND IF IS NOT IN VISITED LINKS FOLLOW WITH ITS
    i = 0
    while (i<search_limit && frontier.size > 0)
      first_link = frontier.shift
      if visited_links.include? (first_link.value) #zawiera sie w visited links
        i=i+1
        next
      end
      visited_links.add( first_link.value )

      begin
        timeout(10) do
          doc = Nokogiri::HTML(open (first_link.value)   , "User-Agent" => AGENT)
        end
      rescue Timeout::Error
        puts '---------- TIMEOUT OCCURED ------------'
        puts 'here: ' + first_link.value
        next
      rescue
        puts '---------- STH STRNGE HAPPEND :( ------------'
        puts 'here: ' + first_link.value
        next
      end

      evaluation =  Evaluator.evaluate_website(first_link, doc, word_list)
      if evaluation > threshold
          first_link.website_evaluation= evaluation
          found_links.push(first_link)
      end
      puts first_link.value  + " ----> " + evaluation.to_s


      extracted_website_links = get_all_links_from_website(first_link.value, doc)
      frontier = frontier + extracted_website_links
      puts 'FRONTIER size: ' + frontier.size.to_s


      i = i+1
    end





