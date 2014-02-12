#!/usr/bin/env ruby
#encoding: utf-8

require 'sinatra'
require 'utf8-cleaner'

require_relative 'lib/helpers'
require_relative 'lib/fetcher'

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
	@render = WebPage.new(params[:url]).render
	erb :upside_down
end

get '/test' do
	IO.read 'views/test.html'
end
