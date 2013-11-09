#!/bin/env ruby
# encoding: utf-8

require_relative 'helpers/synonyms'


a =  Synonyms::get_synonyms('charakteryzować się')

puts a
puts a.length




