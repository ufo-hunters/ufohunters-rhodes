require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class SightingController < Rho::RhoController
  include BrowserHelper

  # GET /Sighting
  def index
    response = Rho::AsyncHttp.get(:url => Rho::RhoConfig.REST_BASE_URL + "reports.json",
      :headers => {"Content-Type" => "application/json"})
    @sightings = response["body"]

    render :back => '/app'
  end

  # GET /Sighting/{1}
  def show
    id = @params['id']
    
    response = Rho::AsyncHttp.get(:url => Rho::RhoConfig.REST_BASE_URL + "reports/" + id +".json",
      :headers => {"Content-Type" => "application/json"})

    @sighting = response["body"]

  end

  def map_it

    map_params = {
     :provider => 'OSM',
     :settings => {:map_type => "hybrid",:region => [@params['latitude'], @params['longitude'], 0.2, 0.2],
                   :zoom_enabled => true,:scroll_enabled => true,:shows_user_location => false},
     :annotations => [{
                      :latitude => @params['latitude'], 
                      :longitude => @params['longitude'], 
                      :title => @params['location'], 
                      :subtitle => @params['sighted_at']
                      }]
    }
    MapView.create map_params

    #redirect :action => :index

  end

=begin
  # GET /Sighting/new
  def new
    @sighting = Sighting.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Sighting/{1}/edit
  def edit
    @sighting = Sighting.find(@params['id'])
    if @sighting
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Sighting/create
  def create
    @sighting = Sighting.create(@params['sighting'])
    redirect :action => :index
  end

  # POST /Sighting/{1}/update
  def update
    @sighting = Sighting.find(@params['id'])
    @sighting.update_attributes(@params['sighting']) if @sighting
    redirect :action => :index
  end

  # POST /Sighting/{1}/delete
  def delete
    @sighting = Sighting.find(@params['id'])
    @sighting.destroy if @sighting
    redirect :action => :index  
  end
=end
end
