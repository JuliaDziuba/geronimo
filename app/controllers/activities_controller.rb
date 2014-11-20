class ActivitiesController < ApplicationController
  
  before_filter :signed_in_user
  before_filter :correct_user, except: [:new, :create, :index]

  def new 
    session[:return_to] = request.referer
    @activity = current_user.activities.build()
    @categories = Activity::CATEGORY_ID_NAME_HASH
    @clients = current_user.clients.order_name.all
    @venues = current_user.venues.order_name.all
    @works = getWorksForForm(@activity)
    if params.has_key?(:category)
      @category = Activity::CATEGORY_NAME_OBJECT_HASH[params[:category]]
    end
    if params.has_key?(:client)
      @client = Client.find_by_munged_name(params[:client])
    end
    if params.has_key?(:venue)
      @venue = Venue.find_by_munged_name(params[:venue])
    end
  end

  def getWorksForForm(activity)
    works = current_user.works.order_title
    aws = {}
    activity.activityworks.all.map{ |aw| aws[aw.id] = aw.quantity}
    works.each do |work|
      if aws.keys.include? work.id
        work.quantity = aws[work.id]
        work.share = 1
      else 
        work.quantity = "0"
        work.share = 0
      end
    end
    works
  end

  def create
    @activity = current_user.activities.build(params[:activity])
    @activity = @activity.set_activity_defaults
    @works = params[:works]
    if @activity.save

      @works.each do | key, value |
        quantity = value["quantity"].to_s.delete(",").to_i
        if quantity > 0 
          work_id = current_user.works.find_by_inventory_id(key).id
          aw = @activity.activityworks.build(:work_id => work_id, :quantity => quantity)
          aw.save
        end
      end
      redirect_to edit_activity_path(@activity)
    else
      @works = getWorksForForm(@activity)
      @categories = Activity::CATEGORY_ID_NAME_HASH
      @clients = current_user.clients.order_name.all
      @venues = current_user.venues.order_name.all
      render 'new'
    end
  end

  def edit
    @activity = current_user.activities.find_by_id(params[:id])
    @category = Activity::CATEGORY_ID_OBJECT_HASH[@activity.category_id]
    @activityworks = @activity.activityworks.all
    @categories = Activity::CATEGORY_ID_NAME_HASH
    @clients = current_user.clients.order_name.all
    @venues = current_user.venues.order_name.all
    @works = getWorksForForm(@activity)
    @new = []
  end

  def update
    @activity = current_user.activities.find_by_id(params[:id])
    @activity.attributes = params[:activity]
    activityworks_params = cleanNumbers(params[:activityworks])
    @activityworks = Activitywork.update( activityworks_params.keys, activityworks_params.values).reject { |w| w.errors.empty? }
    if @activityworks.empty? && @activity.save
      removeZeroQuantities(params[:activityworks].keys)
      redirect_to activities_path
      cleanNumbers(params[:new]).each do | key, value |
        if value["work_id"].to_i > 0 
          aw = @activity.activityworks.build(value)
          aw.save
        end
      end
    else
      @category = Activity::CATEGORY_ID_OBJECT_HASH[@activity.category_id]
      @categories = Activity::CATEGORY_ID_NAME_HASH
      @clients = current_user.clients.order_name.all
      @venues = current_user.venues.order_name.all
      @works = getWorksForForm(@activity)
      render 'edit'
    end
  end

  def removeZeroQuantities(aw_ids)
    aws = Activitywork.find(aw_ids)
    aws.each do |aw|
      aw.delete if aw.quantity == 0
    end
  end

  def show
    @activity = current_user.activities.find_by_id(params[:id])
    @category = Activity::CATEGORY_ID_OBJECT_HASH[@activity.category_id]
    @activityworks = @activity.activityworks.all
  end

  def index
  	if params.has_key?(:category)
      filter = params[:category]
      @activities = current_user.activities.of_type(filter).order_date_start.all(:include => [:client, :venue, :activityworks])
      if @activities.count == 0
        redirect_to new_activity_path(:category => filter) and return
      else
        @category = Activity::CATEGORY_NAME_OBJECT_HASH[params[:category]]
      end   
    else
      @activities = current_user.activities.order_date_start.all(:include => [:client, :venue, :activityworks])
    end
    respond_to do |format|
      format.html
      format.csv { send_data Activity.to_csv(@activities, filter), :filename => "#{filter}.csv" }
    end
  end

	def destroy
    current_user.activities.find_by_id(params[:id]).destroy
    redirect_to activities_path
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
