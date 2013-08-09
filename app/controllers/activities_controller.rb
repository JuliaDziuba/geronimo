class ActivitiesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :correct_user, except: [:create, :index]

  def create
    @activity = current_user.activities.build(params[:activity])
    @success = activity_plays_nice_with_others(@activity)
    if @success
      flash[:success] = "Your new activity was recorded!"
      redirect_to activities_path
    else
      @activities = current_user.activities.all
      @activitycategories = Activitycategory.all
      @works = current_user.works.all
      @venues = current_user.venues.all
      @clients = current_user.clients.all
      render 'index'
    end
  end

  def edit
    @activity = current_user.activities.find_by_id(params[:id])
    @activitycategories = Activitycategory.all
    @works = current_user.works.all
    @venues = current_user.venues.all
    @clients = current_user.clients.all
  end

  def update
    @activity = current_user.activities.find_by_id(params[:id])
    @activity.attributes = params[:activity]
    @success = activity_plays_nice_with_others(@activity)
    if @success
      flash[:success] = "The activity was updated!"
      redirect_to activities_path
    else
      @activitycategories = Activitycategory.all
      @works = current_user.works.all
      @venues = current_user.venues.all
      @clients = current_user.clients.all
      render 'edit'
    end
  end

  def show
    @activity = current_user.activities.find_by_id(params[:id])
    @activitycategories = Activitycategory.all
    @works = current_user.works.all
    @venues = current_user.venues.all
    @clients = current_user.clients.all
  end

  def index
  	@activities = current_user.activities.all(:include => [:activitycategory, :work, :venue, :client])
    @activity = Activity.new
    @activitycategories = Activitycategory.all
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
        flash[:error]= "This work is already " + status(@work) + ". It is not available for " +  Activitycategory.find_by_id(activity.activitycategory_id).name.downcase + ". If this is not correct please correct the previous activities before creating this new one."  
        false
      elsif activity.is_final_but_occurs_before_existing_activities
        flash[:error]= "The new activity you tried to create is final but our records show activities after this one. If this is not a mistake please delete these later records and then try creating this new activity again."
        false
      else
        if activity.starts_before_existing_activity_ended
          activity.activity_before.update_attributes(date_end: activity.date_start)
          flash[:warning] = "Records show this work was " + Activitycategory.find_by_id(activity.activity_before.activitycategory_id).status.downcase + " at the time this new record starts. We updated this previous record to end at the start of this new one." 
        end
        if activity.ends_after_existing_activity_started
          activity[:date_end] =  activity.activity_after.date_start
          flash[:warning] += "Records show this work was also " + Activitycategory.find_by_id(activity.activity_after.activitycategory_id).status.downcase + " on " + activity.activity_before.date_start.to_s() + ". We set the end of the new record you are creating to this date."
        end
        activity.save
      end
    else false
    end
  end

  private

    def correct_user
      @activity = current_user.activities.find_by_id(params[:id])
      if @activity.nil?
        flash[:error] = "Sorry that work activity does not belong to you!"
        redirect_to activities_path
      end
    end

end
