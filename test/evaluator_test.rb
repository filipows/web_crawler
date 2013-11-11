#!/bin/env ruby
# encoding: utf-8

require 'minitest/autorun'
require_relative '../main/evaluator'
require_relative '../main/helpers/synonyms'

class EvaluatorTest < MiniTest::Unit::TestCase




  def test_one_occurence_in_link_should_return_one
    word_list = %w{gastronomia jedzenie spanie costam}
    link = 'http://www.gastronomia-wroclawska.com/kuchnia.php'

    expected = 1
    actual = Evaluator::count_occurences_in_url word_list, link

    assert_equal( expected, actual )
  end

  def test_empty_word_list_should_return_zero_occurences
    word_list = %w{}
    link = 'http://www.grastronomia-wroclawska.com/kuchnia.php'

    expected = 0
    actual = Evaluator::count_occurences_in_url word_list, link

    assert_equal( expected, actual )
  end

  def test_tu_wroclaw_restauracje_search_link
    word_list = %w{gastronomia jedzenie wrocław}
    link = 'http://www.tuwroclaw.com/katalog-firm,restauracje,kfi1-2936.html'

    expected = 1
    actual = Evaluator::count_occurences_in_url word_list, link

    assert_equal( expected, actual )
  end


  def test_count_occurences_with_synonyms
    word_list = %w{żywność}
    link = 'http://www.polskie-jedzenie'  # żywność to synonim jedzenie

    extended_word_list = Synonyms::get_extended_word_list(word_list)
    expected = 1
    actual = Evaluator::count_occurences_in_url extended_word_list, link

    assert_equal( expected, actual )
  end
end

