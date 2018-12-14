require 'HTTParty'

class CheatSheetsPost
  def initialize(data)
    @scrapper_data = data.to_json
    File.write('output.md', data.to_json)
    # @url = 'http://localhost:3000/scraper_api'
    # @url = 'https://cheatsheet-meet.herokuapp.com/scraper_api'
  end

  def call
    HTTParty.post(@url,
                  :body => @scrapper_data,
                  :headers => { 'Content-Type' => 'application/json' })
  end
end
