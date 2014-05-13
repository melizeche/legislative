require 'billit_representers/models/bill_page'

class MainsController < ApplicationController
  caches_page :index, :sitemap

  # GET /mains
  def index
    @low_chamber_agenda = Array.new
    @high_chamber_agenda = Array.new
  
    if ENV['component_legislative_agendas']
	    @low_chamber_agenda[0] = get_current_chamber_agenda ENV['low_chamber_name']
	    @low_chamber_agenda[1] = get_bills_per_agenda JSON.parse(@low_chamber_agenda[0]['bill_list']).uniq

	    @high_chamber_agenda[0] = get_current_chamber_agenda ENV['high_chamber_name']
	    @high_chamber_agenda[1] = get_bills_per_agenda JSON.parse(@high_chamber_agenda[0]['bill_list']).uniq
    end

    @hot_bills = Billit::BillPage.get(ENV['billit_url'] + URI::escape("search?current_priority=Discusión%20inmediata|Suma|Simple&per_page=8"), 'application/json').bills

    if (!ENV['writeit_url_base'].blank?)
	    @answers = LegislativeAnswerCollection.get()

	    if @answers.objects.length > 2
	      @answers.objects = @answers.objects[0..1]
	    end
    end
  end

  # GET last chamber agenda
  def get_current_chamber_agenda chamber
    query = sprintf("select * from data where chamber = '%s' order by date DESC limit 1", chamber)
    query = URI::escape(query)
    response = RestClient.get(ENV['agendas_url'] + query, :content_type => :json, :accept => :json, :"x-api-key" => ENV['morph_io_api_key'])
    response = JSON.parse(response).first
  end

  # GET the bills per agenda
  def get_bills_per_agenda bills_id
    @keywords = String.new
    bills_id.each do |bill_id|
      @keywords << bill_id + '|'
    end
    @keywords = URI::escape(@keywords)
    bills = Billit::BillPage.get(ENV['billit_url'] + "search/?uid=#{@keywords}", 'application/json')
  end

  def sitemap
    @congressmen = PopitPersonCollection.new
    @congressmen.get ENV['popit_persons']+'?per_page=200', 'application/json'
    @congressmen.persons.sort! { |x,y| x.name <=> y.name }
  end
end
