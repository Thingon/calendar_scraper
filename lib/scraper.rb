#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'

class Container
	# shortcut for writing
	#
	# def parser=(val)
	#  	@parser = val
	# end
	#
	# def parser
	#  	@parser
	# end
	#
    attr_accessor :parser

    def initialize
		url = HTTParty.get(ARGV[0])
		@parser ||= Nokogiri::HTML(url)
        @inners = []
    end
    def add_inner(inner)
        @inners << inner
    end
    def get_next(inner)
        @outer.css(inner)
    end
    def get_element
        parse_tags(ARGV[1])
    end
    def parse_tags(tag)
        arr = tag.split(" ")
        result = parser.css(arr[0])
        arr.each do|a|
            result = result.css(a)
        end
        return result
    end
end

puts ARGV[0]

#Define container to search through
container = lambda do 
    elements = []
    attempts = 0
    while elements.empty?
        attempts += 1
        if attempts > 10
            puts "Scraping failed - check the URL or tags"
            break
        end
        outer = Container.new
        elements = outer.get_element.children.map { |elements| elements.text }.compact
    end
    return elements
end
    
texts = container.call

# loop from 0 to events size
(0...texts.size).each do |index|
	puts "\n===== Element: #{index+1} ====="
	puts "#{texts[index]}"
end

