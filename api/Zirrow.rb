require 'httparty'
class Zirrow
	include HTTParty
	@@base = 'http://www.zillow.com/webservice'
	base_uri @@base

	attr_accessor :apis, :github

	def initialize options={}
		require 'json'
		@options = {
			:key => '',
			:docs => 'http://www.zillow.com/howto/api'
		}.merge options

		@apis = {
			'demographics' => {
				:url     => 'GetDemographics',
			},
			'search' => {
				:url     => 'GetSearchResults',	
			},
			'deepsearch' => {
				:url     => 'GetDeepSearchResults',	
			},
			'zestimate' => {
				:url     => 'GetZestimate',
			},
			'chart' => {
				:url     => 'GetChart',		
			},
			'comps' => {
				:url     => 'GetComps',
			},
			'deepcomps' => {
				:url     => 'GetDeepComps',
			},
			'children' => {
				:url     => 'GetRegionChildren',
			},
			'details' => {
				:url     => 'GetUpdatedPropertyDetails',
			},
			'rate' => {
				:url     => 'GetRateSummary',
			},
			'monthly_payments' => {
				:url     => 'GetMonthlyPayments',
			},
			'monthly_payments_advanced' => {
				:url     => 'CalculateMonthlyPaymentsAdvanced',
				:section => 'mortgage',
			},
			'afford' => {
				:url 	 => 'CalculateAffordability',
				:section => 'mortgage',
			},
			'refinance' => {
				:url     => 'CalculateRefinance',
				:section => 'mortgage',
			},
			'adjustable_mortgage' => {
				:url     =>	'CalculateAdjustableMortgage',
				:section => 'mortgage',
			}
		}

		@selectors = {
			:description => '#corpright p:first',
			:parameters  => '#corpright table:first td:nth-child(1)',
			:needed      => '#corpright table:first td:nth-child(3)',
			:expect      => '#corpright table:nth-child(2)',
			:example     => '#corpright p.linkcode',
		}

		@github = 'https://github.com/dancrew32/zirrow'
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
			'state'    => nil,
			'output'   => 'json',
			'callback' => nil,
		}.merge o

		req __method__, o
	end

	# MONTHLY PAYMENTS
	def monthly_payments o={}
		o = {
			'price'       => nil, # req
			'down'        => nil,
			'dollarsdown' => nil,
			'zip'         => nil,
			'output'      => 'json',
			'callback'    => nil,
		}.merge o

		req __method__, o
	end

	def monthly_payments_advanced o={}
		o = {
			'price'        => nil, # req
			'down'         => nil, # req
			'amount'       => nil, # req*
			'rate'         => nil,
			'schedule'     => 'none',
			'terminmonths' => nil,
			'propertytax'  => nil,
			'hazard'       => nil,
			'pmi'          => nil,
			'hoa'          => 0,
			'zip'          => nil,
			'output'       => 'json',
			'callback'     => nil,
		}.merge o

		req __method__, o
	end

	# AFFORDABILITY
	def afford o={}
		o = {
			'annualincome'   => nil, # req
			'monthlypayment' => nil, # req*
			'down'           => nil, # req*
			'monthlydebts'   => nil, # req
			'rate'           => nil,
			'schedule'       => nil,
			'term'           => nil,
			'debttoincome'   => nil,
			'incometax'      => nil,
			'estimate'       => nil,
			'propertytax'    => nil,
			'hazard'         => nil,
			'pmi'            => nil,
			'hoa'            => nil,
			'zip'            => nil,
			'output'         => 'json',
			'callback'       => nil,
		}.merge o

		req __method__, o
	end

	# REFINANCE
	def refinance o={}
		o = {
			'currentamount'   => nil, # req
			'currentrate'     => nil, # req
			'originationyear' => nil, # req
			'currentterm'     => nil, # req
			'newamount'       => nil, # req
			'newrate'         => nil,
			'newterm'         => nil, # req
			'fees'            => nil, # req
			'rollfees'        => nil,
			'cashout'         => nil,
			'schedule'        => nil,
			'output'          => 'json',
			'callback'        => nil,
		}.merge o

		req __method__, o
	end

	# ADJUSTABLE MORTGAGE
	def adjustable_mortgage o={}
		o = {
			'amount'                   => nil, # req
			'rate'                     => nil,
			'schedule'                 => nil,
			'terminmonths'             => nil,
			'monthsbeforeadjustment'   => nil, # req
			'monthsbetweenadjustments' => nil, # req
			'adjustment'               => nil, # req
			'ratecap'                  => nil, # req
			'output'                   => 'json',
			'callback'                 => nil,
		}.merge o

		req __method__, o
	end

=begin


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
		params = []
		reqs   = []
		html.css(@selectors[:parameters]).each_with_index { |n,i| params << n.to_s.chomp! unless i < 1 }
		html.css(@selectors[:needed]).each_with_index { |n,i| 
			next if i < 1
			reqs << n.to_s
		}
		[params, reqs].each { |a| a.delete_if { |x| x == nil } }
		Hash[(params.zip reqs)] # { param => req, ... }
	end

	# WHAT TO EXPECT
	def expect html
		html.css(@selectors[:expect]).to_s
	end

	def example html
		require 'cgi'
		url = html.css(@selectors[:example]).to_s
			.split('<br>').pop().chomp!.gsub!('</p>', '')
			.split(/&lt;ZWSID&gt;&amp;|&lt;ZWSID&lt;/).pop().gsub('&amp;', '&') #kill first part of url
		out = {}
		CGI::parse(url).each do |k,v|
			val = v[0].strip
			val = nil if val == 'cb'
			if is_a_number? val
				val = val.include?('.') ? val.to_f : val.to_i
			end
			out[k] = val
		end
		out.to_s[1..-1][0..-2].gsub('=>', ' => ') # remove { and }
	end

	private

	# MAKE REQUEST
	def req api, body
		section = @apis[api.to_s][:section] ? ("#{@apis[api.to_s][:section]}/") : ''
		body = {
			'zws-id' => @options[:key], # req
		}.merge body

		url = "/#{section}#{@apis[api.to_s][:url]}.htm"
		self.class.post url, :body => body
	end

	def is_a_number? s
		  s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
	end
end
