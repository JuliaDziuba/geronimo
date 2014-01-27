class WorksController < ApplicationController
  before_filter :signed_in_user
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
    current_user.works.find_by_inventory_id(params[:id]).destroy
    redirect_to works_path
  end

  private

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
        works = current_user.works.all(:include =>  [:activities => [:activitycategory, :user, :venue, :client]])
      end
      works 
    end

end

