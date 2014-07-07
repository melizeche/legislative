require 'billit_representers/models/bill'
require 'billit_representers/models/bill_page'
require 'billit_representers/models/bill_basic'
require './app/models/bill'
require './app/models/bill_basic'
require './app/models/billit_paperwork'

class BillsController < ApplicationController
  include Roar::Rails::ControllerAdditions
  caches_page :show
  respond_to :html, :xls

  # GET /bills
  # GET /bills.json
  def index
    redirect_to url_for :controller => 'bills', :action => 'searches'
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    if !ENV['billit_url'].blank?
      @bill = Billit::Bill.get(ENV['billit_url'] + "#{params[:id]}.json", 'application/json')
      if !@bill.blank? and !@bill.title.blank?
        # THE FOLLOWING HAS NOT BEEN TESTED SO IT WILL BE COMMENTED
        # @bill = Billit::Bill.get(ENV['billit_url'] + "#{params[:id]}", 'application/json')

        # # paperworks
        @date_freq = Array.new
        #bill_range_dates = @bill.paperworks.map {|paperwork| Date.strptime(paperwork.date, "%Y-%m-%d")}
        bill_range_dates = @bill.paperworks.map do |paperwork|
          if( !paperwork.date.blank? )
            Date.strptime(paperwork.date, "%Y-%m-%d")
          else
            Date.strptime(Date.today.to_time.to_s, "%Y-%m-%d")
          end
        end

        top_date = Date.today
        bottom_date = top_date - ENV['bill_graph_day_interval'].to_i.days
        data_length = 0
        while data_length < ENV['bill_graph_data_length'].to_i do
          #comparación y agregar a @date_freq
          dates_in_range = bill_range_dates.select {|date| date <= top_date && date > bottom_date}
          #array inverse
          @date_freq.unshift dates_in_range.length
          top_date = bottom_date
          bottom_date = top_date - ENV['bill_graph_day_interval'].to_i.days
          data_length += 1
        end
        # END OF NOT TESTED CODE

        @authors = Hash.new
        i = 0

        if !@bill.authors.blank?
          @bill.authors.each do |author|
            @authors[i] = get_author_related_info author
            i = i + 1
          end
        end

        #setup the title page
        @title = @bill.title + ' - '

        @paperworks = @bill.paperworks
        response_with = @paperworks
      else
        flash[:notice] = t('bill.bill_dont_exist')
        redirect_to url_for :controller => 'bills', :action => 'searches'
      end
    else
      redirect_to url_for :controller => 'bills', :action => 'searches'
    end
  end

  # GET authors related data
  def get_author_related_info author
    a = author.split(',')
    if !a[1].blank?
      author = a[1].strip + ' ' + a[0].strip
    end

    query = sprintf('select * from data where name = "%s" limit 1', I18n.transliterate(author))
    query = URI::escape(query)
    begin
      response = RestClient.get(ENV['congressmen_helper_url'] + query, :content_type => :json, :accept => :json, :"x-api-key" => ENV['morph_io_api_key'])
      response = JSON.parse(response).first
    rescue
      return {'uid' => nil, 'name' => ''}
    end
    if !response.nil?
      return {'uid' => response['uid'], 'name' => author}
    else
      return {'uid' => nil, 'name' => author}
    end
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    #Currently only updates tags
    HTTParty.put(ENV['billit_url']+params[:id]+'.json', body: {tags: params[:tags]})
    render text: params.to_s, status: 201
  end

  def searches
    @title = t('bill.title') + ' - '

    @keywords = String.new
    @bills_query = Hash.new

    if !ENV['billit_url'].blank?
      if !params.nil? && params.length > 3
        # Case with predefined queries selected
        if params['predefined_queries'] != nil
          @keywords = params['predefined_queries'] + '&'
          params.each do |key, value|
            if key != 'utf8' && key != 'locale' && key != 'action' && key != 'controller' && !(value.is_a? Array) && !value.blank? && key != 'predefined_queries' && key != 'creation_date_min' && key != 'creation_date_max'
              @keywords << key + '=' + value + '&'
            elsif (value.is_a? Array)
              @keywords << key + '='
              array_keyword = String.new
              value.each_with_index do |priority_value, index|
                array_keyword << priority_value
                if index < value.size - 1
                  array_keyword << '|'
                end
              end
              @keywords << array_keyword + '&'
            end
          end
        else
          # Case of normal filters
          params.each do |key, value|
            if key != 'utf8' && key != 'locale' && key != 'action' && key != 'controller' && !(value.is_a? Array) && !value.blank?
              @keywords << key + '=' + value + '&'
            elsif (value.is_a? Array)
              @keywords << key + '='
              array_keyword = String.new
              value.each_with_index do |priority_value, index|
                array_keyword << priority_value
                if index < value.size - 1
                  array_keyword << '|'
                end
              end
              @keywords << array_keyword + '&'
            end
          end
        end
        @bills_query = Billit::BillPage.get(ENV['billit_url'] + "search.json/?#{URI.encode(@keywords)}", 'application/json')
      else
        @bills_query = Billit::BillPage.get(ENV['billit_url'] + "search.json/?", 'application/json')
      end
    end
  end
end
