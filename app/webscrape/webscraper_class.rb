# frozen_string_literal:true

require 'HTTParty'
require 'Nokogiri'
require 'json'
BASE_URL = 'https://www.gunviolencearchive.org'
BASE_DIR ='/reports/mass-shooting?page'

# Scraper class to provide webscraping capabilities
class Scraper
  attr_accessor :parse_data

  def initialize(pageNum)
    raw_data = HTTParty.get(BASE_URL + BASE_DIR + "=#{pageNum}")
    @parse_data ||= Nokogiri::HTML(raw_data)
  end

  def scrape_incident_data
    parse_data.css('tbody').css('tr').children.map { |td| td.text }
  end

  @i = 0
  incident_hash_array = []
  while @i <= 30
    scraper = Scraper.new(@i)
    all_incident_info = scraper.scrape_incident_data
    incident_array = []
    page_of_incidents = []
    while all_incident_info.empty? == false
      incident = all_incident_info.slice!(0,8)
      incident.pop
      incident_array.push(incident)
    end
    (0...incident_array.size).each do |index|
      incident_hash = {
        :date => incident_array[index][0],
        :state => incident_array[index][1],
        :city => incident_array[index][2],
        :street => incident_array[index][3],
        :number_killed => incident_array[index][4],
        :number_injured => incident_array[index][5]
      }
      page_of_incidents.push(incident_hash)
      end
      if incident_hash_array[-1]!= page_of_incidents
        incident_hash_array.push(page_of_incidents)
      end
    @i += 1
  end
  incident_hash_array.to_json
end
