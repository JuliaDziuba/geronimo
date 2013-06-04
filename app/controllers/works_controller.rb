class WorksController < ApplicationController
  before_filter :signed_in_user  
  # before_filter :correct_user,   only: :destroy

  def create
    @work = current_user.works.build(params[:work])
    if @work.save
      # flash[:success] = "Your work has been added!"
      redirect_to works_path
    else
      render 'index'
    end
  end

  def update
    @work = current_user.works.find_by_id(params[:id])
    if @work.update_attributes(params[:work])
      redirect_to work_path(@work)
    else
      @workcategories = Workcategory.full_category_names(current_user)
      @activities = @work.activities.all

      @activity = @activity = Activity.new
      @activitycategories = current_user.activitycategories
      @venues = current_user.venues.all_except_storage
      @clients = current_user.clients
      @works  = []
      @works.push(@work)
      render 'show'
      
    end
  end

  def show
    @work = current_user.works.find_by_id(params[:id])
    @workcategories = current_user.workcategories.all
    @activities = @work.activities.all

    @activity = @activity = current_user.activities.build(:work_id => @work.id)
    @activitycategories = current_user.activitycategories
    @venues = current_user.venues.all_except_storage
    @clients = current_user.clients
    @works  = []
    @works.push(@work)
  end

  def index
    @categoryfilter = params[:categoryfilter]
    @statusfilter = params[:statusfilter]
    @parentcategories = current_user.workcategories.parents_only
    @workcategories = workcategories_showing_families
    if !@categoryfilter.nil? 
      @categoryfilter = @categoryfilter.split('.')
      if @categoryfilter.last == "Uncategorized"
        @works = current_user.works.uncategorized
      else !@categoryfilter.nil?
        @works = current_user.works.where('works.workcategory_id = ?', current_user.workcategories.find_by_name(@categoryfilter.last))
      end
    elsif !@statusfilter.nil?
      if @statusfilter == "Available"
        @works = current_user.works.available
      else 
        @works = []
        current_user.works.all.each do |work|
          @works.push(work) if work.status.split(' ').first == @statusfilter
        end
      end
    else
      @works = current_user.works.all
    end
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

    def workcategories_showing_families
      @categories = []
      current_user.workcategories.parents_only.each do |parent|
        @categories.push(parent)
        if parent.children.any?
          parent.children.each do |child|
            child.name = parent.name + " > " + child.name
            @categories.push(child)
          end
        end
      end

    end

end

