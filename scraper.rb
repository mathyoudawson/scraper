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
    request[:payload] = extract_output_from_page
    request
  end

  private

  def extract_output_from_page
    output = []
    @page.css('.grid-lg-1-3').each do |body| 
      body.css('h2').each do |category| 
        obj = {}
        term_list = extract_commands_from_lists(body)
        obj[:category] = category.children.text
        obj[:commands] = term_list
        output << obj
      end
    end
    output
  end

  def extract_commands_from_lists(body)
    term_list = []
    body.css('ul').css('li').each do |content| 
      term_list << extract_term(content)
    end
    term_list
  end

  def extract_term(content)
    {
      :term => content.css('kbd').children.text,
      :description => content.children.text
    }
  end

  def extract_term_list

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
