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

  def get_incident_data
    parse_data.css('tbody').css('tr').children.map { |td| td.text }
  end

  scraper = Scraper.new
  all_incident_info = scraper.get_incident_data
  incident_array = []
  while all_incident_info.size > 0
    incident = all_incident_info.slice!(0,8)
    incident.pop
    incident_array.push(incident)
  end
  p incident_array
  # .join(' ').split('  ')
  # (0...all_inciden t_info.size).each do |index|
  #   puts "- - - index #{index + 1} - - -"
  #   puts "Name: #{all_incident_info[index]}"
  # end
end
