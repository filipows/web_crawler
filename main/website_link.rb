class WebsiteLink
  attr_accessor :value, :description, :link_evaluation, :parent_website_evaluation, :website_evaluation

  def initialize(value, description='', link_evaluation=0, parent_website_evaluation = 0, website_evaluation=0)
    @value = value
    @description = description
    @link_evaluation = link_evaluation
    @website_evaluation = website_evaluation
    @parent_website_evaluation = parent_website_evaluation
  end
end