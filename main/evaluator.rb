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

#  EXAMPLE 3: evaluate_page
#   url = 'http://www.zumi.pl/gastronomia+Wroc%C5%82aw,namapie.html'
#   word_list = %w{wrocław gastronomia obiad obiadowe obiadami obiadowy śniadanie śniadania śniadaniowy kolacja kolacje jedzenie pizza}
#   extended_word_list = Synonyms.get_extended_word_list(word_list)
#   puts Evaluator.evaluate_page(extended_word_list, url)

require 'i18n'
require 'nokogiri'

class Evaluator
  AGENT = 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (HTML, like Gecko) Chrome/31.0.1650.16 Safari/537.36'

  def self.evaluate_page (word_list, url)
    doc = Nokogiri::HTML(open (url)   , "User-Agent" => AGENT)
    in_doc = count_occurences_in_doc(word_list, doc)
    in_url = count_occurences_in_url(word_list, url)

    return in_url * 10 + in_doc
  end


  def self.count_occurences_in_url (word_list, link)
    #count occurences in for ex: link
    occurences = 0
    word_list.each.count do |word|
      #puts link.scan(/#{word}/i)  # display occured words
      word = I18n.transliterate(word)
      occurences += link.scan(/#{word}/i).length
    end
    occurences
  end

  def self.count_occurences_in_doc(word_list, doc)
    doc.css('script').remove # Remove <script>..</script>  Source w/o script blocks
    doc.xpath("//@*[starts-with(name(),'on')]").remove # Remove on____ attributes Source w/o any JavaScript
    text_without_accensts = I18n.transliterate(doc.text)
    website_word_list = text_without_accensts.split(' ')

    #count occurences
    occurences = 0
    website_word_list.each do |word|
      occured = false
      word_list.each do |w|
        occured = true if word.scan(/#{w}/i).length != 0
      end
      occurences += 1 if occured == true
    end
    occurences
  end

end