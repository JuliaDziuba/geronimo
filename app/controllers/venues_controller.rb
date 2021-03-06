class VenuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :canHaveMoreVenues?, only: :create
  before_filter :correct_user, except: [:new, :create, :index]
  
  def  new
    @venue = Venue.new
  end

  def create
    @venue = current_user.venues.build(params[:venue])
    if @venue.save
      flash[:success] = "Your new venue has been added!"
      redirect_to venues_path
    else
      render 'new'
    end
  end

  def show
    @venue = current_user.venues.find_by_munged_name(params[:id])
    @activities = @venue.activities.all 
    @notes = @venue.notes.order_date.all
    @actions = @venue.actions.order_due.all
    @test = true
  end

  def edit
    @venue = current_user.venues.find_by_munged_name(params[:id])
    @activities = @venue.activities.all 
    @notes = @venue.notes.order_date.all
    @actions = @venue.actions.order_due.all
    render 'show'
  end

  def update
    @venue = current_user.venues.find_by_munged_name(params[:id]) 
    if @venue.default?
      redirect_to venues_path, alert: "Sorry this venue cannot be modified."
    else
      @venue.assign_attributes(params[:venue])
      if @venue.valid?
        @venue.save
        flash[:success] = "The venue has been updated!"
        redirect_to venue_path(@venue)
      else
        @activities = @venue.activities.all 
        @notes = @venue.notes.order_date.all
        @actions = @venue.actions.order_due.all
        render 'show'
      end
    end
  end

  def index
    @venues = current_user.venues.order_name.all
    respond_to do |format|
      format.html
      format.csv { send_data Venue.to_csv(@venues) }
    end
  end

  def destroy
    @venue = current_user.venues.find_by_munged_name(params[:id])
    if @venue.default?
      redirect_to venues_path, alert: "Sorry this venue cannot be deleted."
    else
      @activities = @venue.activities.all
      if @activities.any?
        @activities.each do |activity|
          activity.update_attributes(:venue_id => current_user.venues.find_by_name(Venue::DEFAULT).id)
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

    def canHaveMoreVenues?
      tier = current_user.tier
      limit = User::TIER_LIMITS[tier]["venues"]
      canHaveMore = limit.nil? || current_user.venues.all.count < limit 
      if !canHaveMore
        flash[:error] = "Sorry you have reached the limit of venues for your subscription level: #{tier}. Please upgrade your account before adding another work."
        redirect_to account_user_path(current_user) 
      end
    end

end