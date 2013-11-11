#!/bin/env ruby
# encoding: utf-8

require_relative 'helpers/synonyms'
require_relative 'link_extractor'
require_relative 'evaluator'
require 'nokogiri'
require 'i18n'

AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'


url = 'http://www.gastronauci.pl/pl/restauracje/wroclaw'
url2 = 'http://pl.wikipedia.org/wiki/Gastronomia'
url3 = 'http://www.gastronomia.wroclaw.pl/'
url4 = 'http://www.zsg.wroclaw.pl/'
url5 = 'http://www.zumi.pl/gastronomia+Wroc%C5%82aw,namapie.html'
word_list = %w{wrocław gastronomia obiad obiadowe obiadami obiadowy śniadanie śniadania śniadaniowy kolacja kolacje jedzenie pizza}

extended_word_list = Synonyms.get_extended_word_list(word_list)

puts Evaluator.evaluate_page(extended_word_list, url)
puts Evaluator.evaluate_page(extended_word_list, url2)
puts Evaluator.evaluate_page(extended_word_list, url3)
puts Evaluator.evaluate_page(extended_word_list, url4)
puts Evaluator.evaluate_page(extended_word_list, url5)


