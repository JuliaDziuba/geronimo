class ActivitiesController < ApplicationController

  def create
    @activity = Activity.new(params[:activity])
    @success = activity_plays_nice_with_others(@activity)
    if @success
      flash[:success] = "Your new activity was recorded!"
      redirect_to activities_path
    else
      @activities = current_user.activities.all
      @activitycategories = current_user.activitycategories
      @works = current_user.works.all
      @venues = current_user.venues.all
      @clients = current_user.clients
      render 'index'
    end
  end

  def edit
    @activity = current_user.activities.find_by_id(params[:id])
    @activitycategories = current_user.activitycategories
    @works = current_user.works.all
    @venues = current_user.venues.all
    @clients = current_user.clients
  end

  def update
    @activity = Activity.find_by_id(params[:id])
    @activity.attributes = params[:activity]
    @success = activity_plays_nice_with_others(@activity)
    if @success
      flash[:success] = "The activity was updated!"
      redirect_to activities_path
    else
      @activitycategories = current_user.activitycategories
      @works = current_user.works.all
      @venues = current_user.venues.all
      @clients = current_user.clients
      render 'edit'
    end
  end

  def show
    @activity = current_user.activities.find(params[:id])
    @activitycategories = current_user.activitycategories
    @works = current_user.works.all
    @venues = current_user.venues.all
    @clients = current_user.clients
  end

  def index
  	@activities = current_user.activities.all
    @activity = Activity.new
    @activitycategories = current_user.activitycategories
    @works = current_user.works.all
    @venues = current_user.venues.all
    @clients = current_user.clients
  end

	def destroy
    current_user.activities.find_by_id(params[:id]).destroy
    redirect_to activities_path
  end

  def activity_plays_nice_with_others(activity)
    if activity.valid?
      @work = current_user.works.find_by_id(activity.work_id)
      if activity.occurs_after_existing_final_activity
        flash[:error]= "This work is already " + @work.status + ". It is not available for " +  current_user.activitycategories.find_by_id(activity.activitycategory_id).name.downcase + ". If this is not correct please correct the previous activities before creating this new one."  
        false
      elsif activity.is_final_but_occurs_before_existing_activities
        flash[:error]= "The new activity you tried to create is final but our records show activities after this one. If this is not a mistake please delete these later records and then try creating this new activity again."
        false
      else
        if activity.starts_before_existing_activity_ended
          activity.activity_before.update_attributes(date_end: activity.date_start)
          flash[:warning] = "Records show this work was " + current_user.activitycategories.find_by_id(activity.activity_before.activitycategory_id).status.downcase + " at the time this new record starts. We updated this previous record to end at the start of this new one." 
        end
        if activity.ends_after_existing_activity_started
          activity[:date_end] =  activity.activity_after.date_start
          flash[:warning] += "Records show this work was also " + current_user.activitycategories.find_by_id(activity.activity_after.activitycategory_id).status.downcase + " on " + activity.activity_before.date_start.to_s() + ". We set the end of the new record you are creating to this date."
        end
        activity.save
      end
    else false
    end
  end

end
