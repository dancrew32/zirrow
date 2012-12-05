require 'sinatra'
require './api/Zirrow'

set :site_title,    'Zirrow'
set :public_folder, settings.root + '/public'
set :environment,   :development

@@keys = { :zillow => 'defaultkey' }

helpers do
	require './helpers'
end

before do
	@z_key = params.fetch 'z_key', @@keys[:zillow]
	@z     = Zirrow.new :key => @z_key
end

get '/' do
	@github = 'https://github.com/dancrew32/zirrow'
	@readme =
	@apis   = []
	@z.apis.each do |k,v| 
		@apis << {
			:path    => (k.to_s),
			:desc    => (@z.how k.to_s),
			:example => v[:example],
			:source  => get_source('Zirrow', k.to_s),
		}
	end
	haml :index
end

get '/demographics' do
	pj @z.demographics 'zip' => 94121	
end

get '/search' do
	pj @z.search 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'	
end

get '/deepsearch' do
	pj @z.deepsearch 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'	
end

get '/zestimate' do
	pj @z.zestimate 'zpid' => 48749425, 'rentzestimate' => true
end

get '/chart' do
	pj @z.chart 'zpid' => 48749425
end

get '/comps' do
	pj @z.comps 'zpid' => 48749425
end

get '/deepcomps' do
	pj @z.deepcomps 'zpid' => 48749425
end

get '/children' do
	pj @z.children 'state' => 'CA'
end

get '/details' do
	pj @z.details 'zpid' => 48749425
end
