# frozen_string_literal:true

require 'HTTParty'
require 'Nokogiri'
require 'json'

# Scraper class to provide webscraping capabilities
class Scraper
  attr_accessor :parse_data

  def initialize
    # get the raw data from the website using the HTTParty get request
    raw_data = HTTParty.get('https://www.gunviolencearchive.org/reports/mass-shooting')
    @parse_data ||= Nokogiri::HTML(raw_data)
  end

  def scrape_incident_data
    parse_data.css('tbody').css('tr').children.map { |td| td.text }
  end

  # create new instance of scraper
  scraper = Scraper.new
  # scrape and place response into an array
  all_incident_info = scraper.scrape_incident_data
  incident_array = []
  # slice off 9 indexes of all_incident_info at a time (equates to one row of
  # information on the scraped site)
  while all_incident_info.empty? == false
    incident = all_incident_info.slice!(0,8)
    # remove empty index from the end of each selection
    incident.pop
    # add the selection to the incident array
    incident_array.push(incident)
  end
  # for each index of the incident_array create a new has with it's vales and
  # print that to the console
  (0...incident_array.size).each do |index|
    puts incident_hash = {
      'date' => incident_array[index][0],
      'state' => incident_array[index][1],
      'city' => incident_array[index][2],
      'street' => incident_array[index][3],
      'number_killed' => incident_array[index][4],
      'number_injured' => incident_array[index][5]
    }
  end
end
