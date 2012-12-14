def pj json
	require 'json'
	JSON.pretty_generate json
end

def get_source cls, method
	require 'pry'
	Pry::Method.from_str("#{cls}##{method}").source
end

def get_html url
	require 'nokogiri'
	a = Cache.first :url => url
	if a
		Nokogiri::HTML a.content
	else
		require 'open-uri'
		out = ""
		open url do |f|
			out = f.read
		end
		c = Cache.new
		c.url = url
		c.content = out
		c.save
		Nokogiri::HTML out
	end
end

def eval_example
	method = request.path_info[1..-1].to_s
	docs = @@z.docs method
	eval "@z.#{method} #{@@z.example docs}"
end

def eval_term action, args
	begin
		args = '( ' + args.gsub('"', '\'') + ' )'
	rescue
		return "Woops there was a syntax error, please try again."
	end
	eval "@z.#{action}#{args}"
end
