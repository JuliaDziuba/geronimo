class VenuesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def create
    @venue = current_user.venues.build(params[:venue])
    if @venue.save
      # flash[:success] = "Your new type of venues created! Add some venues to it!"
      redirect_to venues_path
    else
      render 'new'
    end
  end

  def update
    @venue = current_user.venues.find_by_id(params[:id]) 
    if @venue.update_attributes(params[:venue])
      redirect_to venue_path(@venue)
    else
      render 'edit'
    end
  end

  def show
    @venue = current_user.venues.find(params[:id])
    @venuecategories = current_user.venuecategories.all
    @currentconsignments = []
    @pastconsignments =[]
    @sales =[]
    consign = current_user.activitycategories.find_by_name('Consign')
    if !consign.nil?
      @currentconsignments = @venue.activities.currentActivityCategory(consign.id)
      @pastconsignments = @venue.activities.previousActivityCategory(consign.id)
    end
    sale = current_user.activitycategories.find_by_name('Sale')
    if !sale.nil?
      @sales = @venue.activities.previousActivityCategory(sale.id)
    end
  end

  def index
    @venue = current_user.venues.build if signed_in?
    @venues = current_user.venues.all
    @venuecategories = current_user.venuecategories.all
  end

  def destroy
    @id = params[:id]
    if @id == 1
      flash[:error] = "You cannot delete this venue! This is the default venue. Feel free to change its name and venue category."
    else
      @venue = current_user.venues.find_by_id(params[:id])
      @activities = @venue.activities.all
      if @activities.any?
        @activities.each do |activity|
          activity.update_attributes(:venue_id => 1)
        end
      end
      @venue.destroy
      redirect_to venues_path
    end
  end

end
