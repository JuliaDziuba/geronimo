class WorksController < ApplicationController
  before_filter :signed_in_user  
  #before_filter :correct_user,   only: :destroy

  def create
    @work = current_user.works.build(params[:work])
    if @work.save
      flash[:success] = "Your work has been added!"
      redirect_to works_path
    else
      @categoryfilter = params[:categoryfilter]
      @statusfilter = params[:statusfilter]
      @parentcategories = current_user.workcategories.parents_only
      @workcategories = current_user.workcategories_showing_families
      @works = works_given_filters(@categoryfilter, @statusfilter)
      @workcategory = Workcategory.new
      render 'index'
    end
  end

  def update
    @work = current_user.works.find_by_id(params[:id])
    if @work.update_attributes(params[:work])
      flash[:success] = "Changes have been saved!"
      redirect_to work_path(@work)
    else
      @workcategories = current_user.workcategories_showing_families
      @activities = @work.activities.all

      @activity = @activity = Activity.new
      @activitycategories = Activitycategory.all
      @venues = current_user.venues.all
      @clients = current_user.clients
      @works  = []
      @works.push(@work)
      render 'show'
      
    end
  end

  def show
    @work = current_user.works.find_by_id(params[:id])
    @workcategories = current_user.workcategories_showing_families
    @activities = @work.activities.all

    @activity = current_user.activities.build(:work_id => @work.id)
    @activitycategories = Activitycategory.all
    @venues = current_user.venues.all
    @clients = current_user.clients
    @works  = []
    @works.push(@work)
  end

  def index
    @categoryfilter = params[:categoryfilter]
    @statusfilter = params[:statusfilter]
    @parentcategories = current_user.workcategories.parents_only.all
    @workcategories = current_user.workcategories_showing_families
    @works = works_given_filters(@categoryfilter, @statusfilter)
    @workcategory = Workcategory.new
    @work = Work.new
  end

  def destroy
    current_user.works.find_by_id(params[:id]).destroy
    redirect_to works_path
  end

  private

    def correct_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to works_path if @work.nil?
    end

    def works_given_filters(categoryfilter, statusfilter)
      if !categoryfilter.nil? 
        categoryarray = categoryfilter.split('.')
        if categoryarray.last == "Uncategorized"
          works = current_user.works.uncategorized
        else
          works = current_user.works.where('works.workcategory_id = ?', current_user.workcategories.find_by_name(categoryarray.last))
        end
      elsif !statusfilter.nil?
        if statusfilter == "Available"
          works = current_user.works.available
        else 
          works = []
          current_user.works.each do |work|
            if work.current_activity == statusfilter
              works.push(work)
            end
          end
        end
      else
        works = current_user.works.all
      end
      works 
    end

end

