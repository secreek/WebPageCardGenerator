#encoding: utf-8

require 'css_parser'
require 'nokogiri'
require 'open-uri'
require 'uri'

require_relative 'uri_util'


def read_css url 
  page = Nokogiri::HTML open(url)
  links = page.css('link')
  css = CssParser::Parser.new
	links.each do |link|
    next unless link['rel'] == "stylesheet"
    begin
      css.load_uri! *URI.get_css_href_and_baseuri(link['href'], url)
    rescue CssParser::RemoteFileError
      puts "Error! while load #{href} base_url #{base_url(url)}."
    end
  end
  css
end 

def inspect_css css, time = 1
  css.each_selector do |selector, declarations, specificity|
    puts "Selector: #{selector}, Specifictiy: #{specificity}"
    #puts "Declatrations: #{declarations}."
    sleep time
  end
end

def read_html url
  page = Nokogiri::HTML open(url)
  page
end


