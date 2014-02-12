#encoding: utf-8
require 'json'
require 'net/http'
require 'sanitize'
require 'readability'

require_relative 'uri_util'
require_relative 'readability_patcher'

class WebPage

	LIGHT_TEXTURE = %w{light1.gif light2.gif light3.gif light4.jpg}
	DARK_TEXTURE = []
	TEXTURES = [LIGHT_TEXTURE, DARK_TEXTURE].flatten

	def initialize(url)
		@url = URI.html_get_web_uri(url)
		@readable = Readability::Document.new open(@url).read, debug: true
		fetch
	end

	def render
		{url: @url, title: @title, content: @content, plain: @plain,
		 extra: @extra, keywords: @keywords, background: @background}
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
		@content = @readable,content
		@plain   = Sanitize.clean(@content).strip
	end

	def fetch_image
		@images = @readable.images_with_fqdn_uris!(@url)
		@image = @images.sample
	end

	def fetch_keywords
		@keywords = Highscore::Content.new(@plain).top(10).map(&:text)
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
