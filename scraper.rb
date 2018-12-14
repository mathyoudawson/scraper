require 'byebug'
require 'Nokogiri'
require 'HTTParty'
require './cheatsheet_post.rb'

class Scraper
  def initialize
    doc = HTTParty.get('https://vim.rtorr.com/')
    @page = Nokogiri::HTML(doc)
  end

  def call
    request = {}
    request.merge!(get_metadata)
    output = []
    @page.css('.grid-lg-1-3').each do |body| 
      body.css('h2').each do |category| 
        obj = {}
        command_list = []
        body.css('ul').each do |list| 
          cmd_list = []
          list.css('li').each do |content|
            cmd_item = {}
            cmd_item[:term] = content.css('kbd').children.text
            cmd_item[:description] = content.children.text
            command_list << cmd_item
          end
        end
        obj[:category] = category.children.text
        obj[:commands] = command_list
        output << obj
      end
    end
    request[:payload] = output
    request
  end

  def get_metadata
    {
      'metadata': {
        'title': 'Vim',
        'description': 'Imported cheatsheet'
      }
    }
  end

  def get_category
  end

  def get_command
  end

  def get_description
  end
end

scrape = Scraper.new
data = scrape.call

post = CheatSheetsPost.new(data)
# post.call
