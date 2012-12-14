class Cache
	include DataMapper::Resource
	property :id,         Serial
	property :url,        String, :length => 75 
	property :content,    Text
	property :created_at, Time
end
