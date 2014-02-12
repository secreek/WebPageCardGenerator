#!/usr/bin/env ruby
#encoding: utf-8

require 'open-uri'
require 'sinatra'
require 'utf8-cleaner'

require_relative 'lib/helpers'
require_relative 'lib/fetcher'
require_relative 'lib/uri_util'

use UTF8Cleaner::Middleware

get '/' do
	index =<<HERE
	url to be fetch: <form method="post" action="/fetch">
	<input type="text" name="url" />
	<input type="submit" value="submit" />
	</form>
HERE
end

post '/fetch' do
	url = params[:url]
	url = "http://#{url}" unless url =~ /\Ahttps?:\/\//i

	unless (url = URI.html_get_web_uri(url))
		redirect_to '/error'
	else
		@render = WebPage.new(params[:url]).render
		erb @render[:layout]
	end

end

get '/test' do
	IO.read 'views/test.html'
end
