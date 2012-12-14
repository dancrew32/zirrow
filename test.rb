require './api/Zirrow'

class Object
	def metaclass
		class << self; self; end
	end
end

class MetaZirrow
	def MetaZirrow.create_method(name, h={})
		#klass = self.to_s
		metaclass.instance_eval do
			define_method(name) do 
				eval "
				h = {
					'test' => 'wat'
				}.merge h
				"
				Zirrow.new.req(__method__.to_s, h).body_str
			end
		end
	end
end

class A < MetaZirrow
	@z = Zirrow.new
	@z.apis.each do |name, data|
		create_method name.to_sym, 'cheese' => 'wat', 'test' => 'beans'
	end
end

