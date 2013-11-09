class LinkProperties
  attr_accessor :url, :description

  def to_s
    "url: #{@url}, description: #{@description}"
  end
end