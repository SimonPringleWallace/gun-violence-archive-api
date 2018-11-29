# frozen_string_literal:true

require 'HTTParty'
require 'Nokogiri'

# Scraper class to provide webscraping capabilities
class Scraper
  attr_accessor :parse_data

  def initialize
    # get the raw data from the website using the HTTParty get request
    raw_data = HTTParty.get('https://www.gunviolencearchive.org/reports/mass-shooting')
    @parse_data ||= Nokogiri::HTML(raw_data)
  end

  def get_date
    parse_data.css('tbody').css('tr').map { |tb| tb.text }
  end

  def put_dates
    put
  end

  scraper = Scraper.new
  dates = scraper.get_date
  p dates
  (0...dates.size).each do |index|
    puts "- - - index #{index + 1} - - -"
    puts "Name: #{dates[index]}"
    puts "foo!"
  end
end
