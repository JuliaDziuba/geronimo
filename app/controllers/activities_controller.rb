class ActivitiesController < ApplicationController

  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      # flash[:success] = "Your new activity is created!"
      redirect_to activities_path
    else
      render 'index'
    end
  end

  def show
    @activity = current_user.activities.find(params[:id])
    @activitycategories = current_user.activitycategories
    @works = current_user.works.available
    @venues = current_user.venues.all_except_storage
    @clients = current_user.clients
  end

  def index
  	@activities = current_user.activities.all
    @activity = Activity.new
    @activitycategories = current_user.activitycategories
    @works = current_user.works.available
    @venues = current_user.venues.all_except_storage
    @clients = current_user.clients
  end

	def edit
    @activity = current_user.activities.find_by_id(params[:id])
    @activitycategories = current_user.activitycategories
  	@works = current_user.works.available
    @venues = current_user.venues.all_except_storage
  	@clients = current_user.clients
  end

  def update
    @activity = Activity.find_by_id(params[:id])
    if @activity.update_attributes(params[:activity])
      redirect_to activities_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.activities.find_by_id(params[:id]).destroy
    redirect_to activities_path
  end
end
