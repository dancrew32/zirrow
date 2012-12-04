Zirrow
=========

[Zirrow](http://zirrow.danmasq.com) is a 
[Zillow Api](http://www.zillow.com/howto/api/APIOverview.htm) 
wrapper written in [Ruby](http://ruby-lang.org/), 
designed to self-document in a [Sinatra](http://www.sinatrarb.com/) app.


## Install

To get all the gems, `bundle install`

If you just want a really simple Zillow Api class, use `/api/Zirrow.rb`
If you want to run the api site, just `rackup config.ru`
No clue what rack is? https://devcenter.heroku.com/articles/rack

You'll need to request a 
[Zillow Api Key](http://www.zillow.com/webservice/APIUpgradeRequest.htm) 
to get rolling.


## What's it do?

Zirrow scrapes the many pages of the 
[Zillow Api Documentation](http://www.zillow.com/howto/api/APIOverview.htm)
for summaries of each api when you create a new method in `Zirrow.rb`
and implement it in the Sinatra app.

## How do I use it?

The following returns search results for this address:

```ruby
@z = new.Zirrow :key => 'myZWSID'
@z.search 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'	
```


## What's it going to do?

Zirrow will eventually scrape the api parameters and dynamically compare
existing parameters to ensure this api wrapper is up to date.

