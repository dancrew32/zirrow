require 'sinatra'
require 'yaml'
require './api/Zirrow'

set :site_title,    'Zirrow'
set :public_folder, settings.root + '/public'
set :environment,   :development

@@z  = Zirrow.new
helpers do
	require './helpers' 
end


before do
	@z_key = params.fetch 'z_key', ''
	@z     = Zirrow.new :key => @z_key
end

get '/' do
	@github = @z.github
	haml :index
end

get '/apis' do
	@apis   = []
	@z.apis.each do |k,v| 
		docs = @z.docs k.to_s
		@apis << {
			:path    => (k.to_s),
			:desc    => (@z.describe docs),
			:param   => (@z.parameters docs),
			:zex     => ("@z.#{k} #{@z.example docs}"),
			:source  => get_source('Zirrow', k.to_s),
		}
	end
	haml :apis
end

@@z.apis.each do |k,v|
	get "/#{k}" do 
		pj eval_example
	end
end
