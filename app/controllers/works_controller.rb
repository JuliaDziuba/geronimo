class WorksController < ApplicationController
  before_filter :signed_in_user  
  # before_filter :correct_user,   only: :destroy

  def create
    @work = Work.new(params[:work])
    if @work.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
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
    #  @work.image1 = nil
      @worksubcategories = subcategories
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
    @worksubcategories = subcategories
    @activities = @work.activities.all

    @activity = @activity = Activity.new
    @activitycategories = current_user.activitycategories
    @venues = current_user.venues.all_except_storage
    @clients = current_user.clients
    @works  = []
    @works.push(@work)
  end

  def index
    @workcategories = current_user.workcategories.all
    @worksubcategories = subcategories
    @works = current_user.works.all
    @workcategory = Workcategory.new
    @worksubcategory = Worksubcategory.new
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

    def subcategories
      @worksubcategories = current_user.worksubcategories
      @worksubcategories.each do |worksubcategory|
        worksubcategory[:name] = worksubcategory.workcategory.name + " > " + worksubcategory.name
      end
    end

end

