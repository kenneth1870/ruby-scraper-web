require 'HTTParty'
require 'nokogiri'
require 'pry'

class Scrapper
  attr_accessor :parse_page

  def initialize
    doc = HTTParty.get('https://store.nike.com/us/en_us/pw/mens-nikeid-lifestyle-shoes/1k9Z7puZoneZoi3')
    @parse_page ||= Nokogiri::HTML(doc)
  end

  def names
    binding.pry
    item_container.css('.product-name')
                  .css('p')
                  .children.map(&:text).compact
  end

  def prices
    item_container.css('.product-price')
                  .css('span.local')
                  .children.map(&:text).compact
  end

  private

  def item_container
    parse_page.css('.grid-item-info')
  end

  scrapper = Scrapper.new
  names    = scrapper.names
  prices   = scrapper.prices

  (0...prices.size).each do |index|
    puts "- - - index #{index + 1} - - -"
    puts "Name: #{names[index]} | Price: #{prices[index]} "
  end
end
