class WorksController < ApplicationController
  before_filter :signed_in_user
  before_filter :canHaveMoreWorks?, only: :create
#  before_filter :correct_user, except: [:create, :index, :edit_multiple, :update_multiple]

  def new
    @workcategories = current_user.workcategories_showing_families
    @work = Work.new
  end

  def create
    @work = current_user.works.build(params[:work])
    if @work.save
      # flash[:success] = "Your work has been added!"
      redirect_to works_path
    else
      @categoryfilter = params[:categoryfilter]
      @statusfilter = params[:statusfilter]
      @parentcategories = current_user.workcategories.parents_only
      @workcategories = current_user.workcategories_showing_families
      @works = works_given_filters(@categoryfilter, @statusfilter)
      @workcategory = Workcategory.new
      render 'new'
    end
  end

  def update
    @work = current_user.works.find_by_inventory_id(params[:id])
    if @work.update_attributes(params[:work])
      flash[:success] = "Changes have been saved!"
      redirect_to work_path(@work)
    else
      @workcategories = current_user.workcategories_showing_families
      @activities = @work.activities.all

      render 'show'
    end
  end

  def update_multiple
    ids = []
    params[:works].keys.each do |inventory_id|
      ids.push(current_user.works.find_by_inventory_id(inventory_id).id)
    end
    @works = Work.update(ids, params[:works].values).reject { |w| w.errors.empty? }
    if @works.empty?
      flash[:notice] = "Works have been updated!"
      redirect_to works_url
    else
      @statusfilter = "failed update"
      @parentcategories = current_user.workcategories.parents_only.all
      @workcategories = current_user.workcategories_showing_families
      @workcategory = Workcategory.new
      @work = Work.new
      render :action => "index"
    end
  end

  def show
    @work = current_user.works.find_by_inventory_id(params[:id])
    @workcategories = current_user.workcategories_showing_families
    @activities = @work.activities.all
    @notes = @work.notes.all
    @actions = @work.actions.all
    if @work.workcategory.nil?
      flash[:info] = "We noticed you wish to make this work public but it is uncategorized! Your public site organizes works using your 'Work Categories' so works must be categorized before they appear publically. Please create a new work category that is appropriate for this work or select an existing one!"
    end
  end

  def index
    @categoryfilter = params[:categoryfilter]
    @statusfilter = params[:statusfilter]
    @parentcategories = current_user.workcategories.parents_only.all(:include => :works)
    @workcategories = current_user.workcategories_showing_families
    @works = works_given_filters(@categoryfilter, @statusfilter)
    @workcategory = Workcategory.new
    @work = Work.new
    respond_to do |format|
      format.html
      format.csv { 
        send_data Work.to_csv(@works) }
    end
  end

  def destroy
    work = current_user.works.find_by_inventory_id(params[:id])
    activities = work.activities.all
    if activities.any?
      activities.each do |activity|
        activity.destroy
      end
    end
    work.destroy
    redirect_to works_path
  end

  private

    def canHaveMoreWorks?
      tier = current_user.tier
      limit = User::TIER_LIMITS[tier]["works"]
      canHaveMore = limit.nil? || current_user.works.all.count < limit 
      if !canHaveMore
        flash[:error] = "Sorry you have reached the limit of works for your subscription level: #{tier}. Please upgrade your account before adding another work."
        redirect_to account_user_path(current_user) 
      end
    end

    def correct_user
      @work = current_user.works.find_by_inventory_id(params[:id])
      if @work.nil?
        flash[:error] = "Sorry that work does not belong to you!"
        redirect_to works_path 
      end
    end

    def works_given_filters(categoryfilter, statusfilter)
      if !categoryfilter.nil? 
        categoryarray = categoryfilter.split('.')
        if categoryarray.last == "Uncategorized"
          works = current_user.works.uncategorized.all(:include =>  [:activities => [:activitycategory, :user, :venue, :client]])
        else
          works = current_user.works.where('works.workcategory_id = ?', current_user.workcategories.find_by_name(categoryarray.last)).all(include: :activities)
        end
      elsif !statusfilter.nil?
        if statusfilter == "Available"
          works = current_user.works.available.all(:include =>  [:activities => [:activitycategory, :user, :venue, :client]])
        else 
          works = []
          current_user.works.all(:include =>  [:activities => [:activitycategory, :user, :venue, :client]]).each do |work|
            if work.current_activity == statusfilter
              works.push(work)
            end
          end
        end
      else
        works = current_user.works.all(:include =>  [:workcategory, :activities => [:activitycategory, :user, :venue, :client]])
      end
      works 
    end

end

