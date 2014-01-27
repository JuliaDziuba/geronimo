class VenuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, except: [:create, :index]
  
  def create
    @venue = current_user.venues.build(params[:venue])
    if @venue.save
      flash[:success] = "Your new venue has been added!"
      redirect_to venues_path
    else
      flash[:error] = "There was an error with the new venue. Please click 'new' to see the issue."
      @venues = current_user.venues.all
      @venuecategories = Venuecategory.all
      render 'index'
    end
  end

  def update

    @venue = current_user.venues.find_by_munged_name(params[:id]) 
    @venue.assign_attributes(params[:venue])
    if @venue.valid?
      @venue.save
      flash[:success] = "The venue has been updated!"
      redirect_to venue_path(@venue)
    else
      flash[:error] = "There was a problem with the changes made to the venue. Please click edit to view error and correct."
      @venuecategories = Venuecategory.all
      render 'show'
    end
  end

  def show
    @venue = current_user.venues.find_by_munged_name(params[:id])
    @venuecategories = Venuecategory.all
  end

  def index
    @venue = current_user.venues.build
    @venues = current_user.venues.all
    @venuecategories = Venuecategory.all
  end

  def destroy
    @id = params[:id]
    if @id == 1
      flash[:error] = "You cannot delete this venue! This is the default venue. Feel free to change its name and venue category."
    else
      @venue = current_user.venues.find_by_munged_name(params[:id])
      @activities = @venue.activities.all
      if @activities.any?
        @activities.each do |activity|
          activity.update_attributes(:venue_id => current_user.venues.all.collect(&:id).min())
        end
      end
      @venue.destroy
      redirect_to venues_path
    end
  end

  private

    def correct_user
      munged_name = params[:id]
      @venue = current_user.venues.find_by_munged_name(params[:id])
      if @venue.nil?
        flash[:error] = "Sorry that venue does not belong to you!"
        redirect_to venues_path
      end
    end

end
