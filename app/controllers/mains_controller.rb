class MainsController < ApplicationController
  def index
    @condition_search = true
    @condition_priority_box = true
    
    #@tables = TableCollection.new
    #@tables.get(ENV['tables_url'],'application/json')

    #@bills = BillCollection.new
    #@bills.get(ENV['billit_url']+'search.json?per_page=6', 'application/json')
  end
end
