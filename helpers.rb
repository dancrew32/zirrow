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

def eval_example
	method = request.path_info[1..-1].to_s
	docs = @@z.docs method
	eval "@z.#{method} #{@@z.example docs}"
end

def eval_term action, args
	eval "@z.#{action}( #{args} )"
end
