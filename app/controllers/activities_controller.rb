class ActivitiesController < ApplicationController
  def new
  	@activity = Activity.new
  	@activitycategories = current_user.activitycategories
  	@venues = current_user.venues
  	@works	= current_user.works
    @clients = current_user.clients
  end

  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      # flash[:success] = "Your new activity is created!"
      redirect_to activities_path
    else
      render 'new'
    end
  end

  def show
    @activity = current_user.activity.find(params[:id])
  end

  def index
  	@activities = current_user.activities.all
    @activity = Activity.new
    @activitycategories = current_user.activitycategories
    @venues = current_user.venues
    @works  = current_user.works
    @clients = current_user.clients
  end

	def edit
    @activity = current_user.activities.find_by_id(params[:id])
    @activitycategories = current_user.activitycategories
  	@venues = current_user.venues
  	@works	= current_user.works
    @clients = current_user.clients
  end

  def update
    if Activity.find_by_id(params[:id]).update_attributes(params[:activity])
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
