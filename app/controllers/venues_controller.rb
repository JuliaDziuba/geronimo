class VenuesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@venues = current_user.venues.all
    @venuecategories = current_user.venuecategories.all
  end

  def show
    @venue = current_user.venues.find(params[:id])
    @venuecategories = @current_user.venuecategories.all
    @activities = @venue.activities.all
    @pastconsignments = @venue.activities.all
    @sales = @venue.activities.all

  end

  def new
  	@venue = current_user.venues.build if signed_in?
    @venuecategories = current_user.venuecategories.all
  end

  def create
    @venue = current_user.venues.build(params[:venue])
    if @venue.save
      # flash[:success] = "Your new type of venues created! Add some venues to it!"
      redirect_to venue_path(@venue)
    else
      render 'new'
    end
  end

  def edit
    @venue = current_user.venues.find_by_id(params[:id])
  end

  def update
    @venue = current_user.venues.find_by_id(params[:id]) 
    if @venue.update_attributes(params[:venue])
      redirect_to venue_path(@venue)
    else
      render 'edit'
    end
  end

  def destroy
    current_user.venues.find_by_id(params[:id]).destroy
    redirect_to venues_path
  end

end
