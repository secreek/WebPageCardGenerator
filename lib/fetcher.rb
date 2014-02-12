#encoding: utf-8
require 'json'
require 'sanitize'
require 'highscore'
require 'readability'

require_relative 'readability_patcher'

class WebPage

	TEXTURE_FOLDER = './img/'
	LIGHT_TEXTURE = %w{light1.gif light2.gif light3.gif light4.jpg greyfloral.png
		                 diamond_upholstery.png}
	DARK_TEXTURE = %w{binding_dark.png} 
	TEXTURES = [LIGHT_TEXTURE, DARK_TEXTURE].flatten

	def initialize(url)
		@url = url
		@readable = Readability::Document.new open(@url).read 
		fetch
	end

	def render
		{url: @url, title: @title, content: @content, plain: @plain,
		 layout: @layout, extra: @extra, keywords: @keywords,
		 image: @image, images: @images, background: @background}
	end

	def to_json(*a)
		render.to_json(*a)
	end

	def fetch
		fetch_title
		fetch_content
		fetch_image
		fetch_keywords
		fetch_extra
		fetch_background
	end

	def fetch_title
		@title = @readable.title.split("|").first
	end

	def fetch_content
		@content = @readable.content
		@plain   = Sanitize.clean(@content).strip
	end

	def fetch_image
		@images = @readable.images_with_fqdn_uris!(@url)
		if @images.empty?
			@image = TEXTURE_FOLDER + DARK_TEXTURE.sample
			@layout = :updown 
		else
			@image = @images.sample
			select_layout
		end
	end

	def select_layout
		size = @readable.get_image_size(@image)
		width, height = size[:width], size[:height]
		rate = width.to_f / height
		puts "width: #{width}, height:#{height}, rate:#{rate}"
		if rate > 0.9 && rate < 1.35
			@layout = :landscape
		elsif width >= 300 || width.to_f / height >= 1.35
			@layout = :updown
		else
			@layout = :landscape
		end
	end	

	def fetch_keywords
		@keywords = Highscore::Content.new(@plain).keywords.top(10).map(&:text)
	end

	def fetch_extra
		# fetch extra info
		# unimplement yet.
	end

	def fetch_background
		# futher version supports fetch target webpage's background
		@background = LIGHT_TEXTURE.sample
	end

end
