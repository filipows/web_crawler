#  EXAMPLE 1: count_occurences_in_link
#    require_relative 'evaluator'
#    word_list = %w{gastronomia wrocław pizza jedzenie}
#    link = 'http://www.grastronomia-wroclawska.com/kuchnia.php'
#    puts Evaluator::count_occurences_in_link word_list, link

#  EXAMPLE 2: count_occurences_in_doc
#   url = 'http://www.gastronauci.pl/pl/restauracje/wroclaw'
#   word_list = %w{obiad obiadowe obiadami obia }
#   doc = Nokogiri::HTML(open (url)   , "User-Agent" => AGENT)
#   puts Evaluator::count_occurences_in_doc(word_list, doc)

#  EXAMPLE 3: evaluate_website
#   url = 'http://www.zumi.pl/gastronomia+Wroc%C5%82aw,namapie.html'
#   word_list = %w{wrocław gastronomia obiad obiadowe obiadami obiadowy śniadanie śniadania śniadaniowy kolacja kolacje jedzenie pizza}
#   extended_word_list = Synonyms.get_extended_word_list(word_list)
#   puts Evaluator.evaluate_website(extended_word_list, url)

require 'i18n'
require 'nokogiri'

class Evaluator
  # nie robienie tej klasy statycznej pozwoliloby definiowac parametry w konstruktorze
  URL_WORD_WEIGTH = 10


  def self.evaluate_website( website_link, doc, word_list )
    begin
      in_doc = count_occurrences_in_doc(word_list, doc)
      in_url = count_occurrences_in_url(word_list, website_link.value)
      #in_description = count_occurrences_in_url(word_list, website_link.description)
    rescue Exception
      return 0
    end

    return in_url * URL_WORD_WEIGTH + in_doc
  end



  def self.count_occurrences_in_url (word_list, link)
    #count occurrences in for ex: link
    occurences = 0
    word_list.each.count do |word|
      #puts link.scan(/#{word}/i)  # display occured words
      word = I18n.transliterate(word)
      occurences += link.scan(/#{word}/i).length
    end
    occurences
  end

  def self.count_occurrences_in_doc(word_list, doc)
    doc.css('script').remove # Remove <script>..</script>  Source w/o script blocks
    doc.xpath("//@*[starts-with(name(),'on')]").remove # Remove on____ attributes Source w/o any JavaScript
    text_without_accensts = I18n.transliterate(doc.text)
    website_word_list = text_without_accensts.split(' ')

    #count occurences
    occurrences = 0
    website_word_list.each do |word|
      occured = false
      word_list.each do |w|
        occured = true if word.scan(/#{w}/i).length != 0
      end
      occurrences += 1 if occured == true
    end
    occurrences
  end

end