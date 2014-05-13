require 'roar/representer'
require 'roar/representer/feature/client'
require 'roar/representer/feature/http_verbs'
require 'roar/representer/json/hal'

class LegislativeMessageCollection
	include Roar::Representer
	include Roar::Representer::JSON::HAL
	include Roar::Representer::Feature::HttpVerbs

	def initialize
		extend Roar::Representer::Feature::Client
		super
	end

	collection :objects, :class => LegislativeMessageRepresenter

	property :meta

	def get(page: 1, person: nil, **options)
		url = URI.join(ENV['writeit_base_url'], ENV['writeit_url'], 'messages/')
		hash_parameters = {
			"format" => "json", 
			"username" => ENV["writeit_username"], 
			"api_key" => ENV["writeit_api_key"], 
			"limit" => ENV["writeit_messages_per_page"],
			"page" => page
		}
		if not person.nil?
			hash_parameters['person__popit_id'] = person.id
		end
		parameters = URI.encode_www_form hash_parameters
		url.query = parameters
		super url.to_s, 'application/json'
	end
end
