#  EXAMPLE:
#    url = 'http://www.loswiaheros.pl/kalendarz'
#    doc = Nokogiri::HTML(open (url)   , "User-Agent" => AGENT)
#    uri = URI url
#    base_link = "#{uri.scheme}://#{uri.host}"

#    puts LinkExtractor::get_internal_links(doc, base_link)
#    puts LinkExtractor::get_external_links(doc)

class LinkExtractor
  def self.get_internal_links(doc ,base_link)
    internal_links = {}
    doc.xpath('//a[@href]').each do |link|
      if internal? link['href']
        full_link =  "#{base_link}#{link['href']}"
        internal_links[link.text.strip] = full_link
      end
    end
    internal_links
  end

  def self.get_external_links(doc)
    external_links = {}
    doc.xpath('//a[@href]').each do |link|
      if !(internal? link['href'])
        external_links[link.text.strip] = link['href']
      end
    end
    external_links
  end


  def self.get_all_links()
  end



  private
  def self.internal? (url)
    url =~ /^\//
  end
end


