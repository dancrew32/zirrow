# DEPENDENCIES
%w(sinatra data_mapper dm-mysql-adapter ./model/cache ./api/Zirrow).each do |r|
	require r
end


# DATABASE (for caching)
DataMapper.setup :default, 'mysql://%s:%s@localhost/%s' % ['user', 'pass', 'dbname']
DataMapper.auto_upgrade!
DataMapper.finalize


# APP SETTINGS
set :site_title, 'Zirrow'
set :public_folder, settings.root + '/public'
set :environment, :development
set :default_key, 'your key'


# HELPERS
helpers { require './helpers' }


# ROUTES
@@z  = Zirrow.new
before do
	@z_key = params.fetch 'z_key', settings.default_key
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

get '/term' do
	action = params.fetch 'action'
	return "Not a valid method." unless @z.apis.keys().include? action

	args = params.fetch 'args', ''
	ct = args.split(' ')
	if (ct.length < 2)
		docs =  @z.docs(action)
		p = @z.parameters docs
		return "Available parameters: #{p.to_s[1..-2]}"
	end

	pj eval_term action, args
end
