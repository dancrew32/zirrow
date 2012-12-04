def pj json
	require 'json'
	JSON.pretty_generate json
end

def get_source cls, method
	require 'pry'
	Pry::Method.from_str("#{cls}##{method}").source
end

def get_html url
	require 'open-uri'
	require 'nokogiri'
	data = open url
	Nokogiri::HTML data
end
