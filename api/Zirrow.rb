require 'httparty'
class Zirrow
	include HTTParty
	base_uri 'http://www.zillow.com/webservice'

	attr_accessor :apis

	def initialize options={}
		require 'json'
		@options = {
			:key => '',
			:docs => 'http://www.zillow.com/howto/api'
		}.merge options

		@apis = {
			'demographics' => {
				:url     => 'GetDemographics',
				:example => "@z.demographics 'zip' => 94121",
			},
			'search' => {
				:url     => 'GetSearchResults',	
				:example => "@z.search 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'",
			},
			'deepsearch' => {
				:url     => 'GetDeepSearchResults',	
				:example => "@z.deepsearch 'address' => '184 17th ave', 'citystatezip' => 'san francisco ca'",
			},
			'zestimate' => {
				:url     => 'GetZestimate',
				:example => "@z.zestimate 'zpid' => 48749425, 'rentzestimate' => true",
			},
			'chart' => {
				:url     => 'GetChart',		
				:example => "@z.chart 'zpid' => 48749425",
			},
			'comps' => {
				:url     => 'GetComps',
				:example => "@z.comps 'zpid' => 48749425",
			},
			'deepcomps' => {
				:url     => 'GetDeepComps',
				:example => "@z.deepcomps 'zpid' => 48749425",
			},
			'children' => {
				:url     => 'GetRegionChildren',
				:example => "@z.children 'state' => 'CA'",
			},
			'details' => {
				:url     => 'GetUpdatedPropertyDetails',
				:example => "@z.details 'zpid' => 48749425",
			},
			'rate' => {
				:url     => 'GetRateSummary',
				:example => "@z.rate 'state' => 'CA'",
			}
		}

		@selectors = {
			:description => '#corpright p:first',
			:parameters  => '#corpright table:first td:nth-child(1)',
			:expect      => '#corpright table:nth-child(2)',
		}
	end

	# DEMOGRAPHICS
	def demographics o={}
		o = {
			'regionId'     => nil,
			'state'        => nil,
			'city'         => nil,
			'neighborhood' => nil,
			'zip'          => nil,
		}.merge o

		req __method__, o
	end

	# SEARCH
	def search o={}
		o = {
			'address'       => nil, # req
			'citystatezip'  => nil, # req
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# DEEPSEARCH
	def deepsearch o={}
		o = {
			'address'       => nil, # req
			'citystatezip'  => nil, # req
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# ZESTIMATE
	def zestimate o={}
		o = {
			'zpid'          => nil, # req	
			'rentzestimate' => false,
		}.merge o

		req __method__, o
	end

	# CHART
	def chart o={}
		o = {
			'zpid'          => nil,      # req	
			'unit-type'     => 'dollar', # req 'percent'
			'width'         => nil,      # 200-600
			'height'        => nil,      # 100-300
			'chartDuration' => nil,      # '1years', '5years', '10years'
		}.merge o

		req __method__, o
	end

	# COMPS
	def comps o={}
		o = {
			'zpid'          => nil,  # req	
			'count'         => '25', # req '1-25'
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# DEEPCOMPS
	def deepcomps o={}
		o = {
			'zpid'          => nil,  # req	
			'count'         => '25', # req '1-25'
			'rentzestimate' => nil,
		}.merge o

		req __method__, o
	end

	# CHILDREN
	def children o={}
		o = {
			'regionId'     => nil, # req*
			'state'        => nil, # req*
			'city'         => nil,
			'neighborhood' => nil,
			'zip'          => nil,
		}.merge o

		req __method__, o
	end

	# DETAILS
	def details o={}
		o = {
			'zpid' => nil, # req
		}.merge o

		req __method__, o
	end

	# RATE
	def rate o={}
		o = {
			'state'         => nil,
			'output'        => 'json',
			'callback'      => nil,
		}.merge o

		req __method__, o
	end

=begin

monthly_payments
GetMonthlyPayments

monthly_payments_advanced
CalculateMonthlyPaymentsAdvanced

afford
CalculateAffordability

refinance
CalculateRefinance

adjustable_mortgage
CalculateAdjustableMortgage

discount_points
CalculateMortgageTerms

bi_weekly_payment
CalculateBiWeeklyPayment

no_cost_vs_traditional
CalculateNoCostVsTraditional

tax_savings
CalculateTaxSavings

fixed_vs_adjustable
CalculateFixedVsAdjustableRate

closing_cost
CalculateClosingCostImpact

interest_vs_traditional
CalculateInterstOnlyVsTraditional

heloc
CalculateHELOC

=end


	# DOCS
	def docs api
		get_html "#{@options[:docs]}/#{@apis[api][:url]}.htm"
	end

	# DESCRIPTION
	def describe html
		out  = ""
		html.css(@selectors[:description]).each { |n| out += n }
		out
	end

	# PARAMS
	def parameters html
		out = []
		html.css(@selectors[:parameters]).each_with_index { |n,i| out << n.to_s.chomp! unless i < 1 or n.to_s == nil }
		out
	end

	# WHAT TO EXPECT
	def expect html
		html.css(@selectors[:expect]).to_s
	end

	private

	# MAKE REQUEST
	def req api, body
		body = {
			'zws-id' => @options[:key], #req
		}.merge body

		url = "/#{@apis[api.to_s][:url]}.htm"
		self.class.post url, :body => body
	end

end
