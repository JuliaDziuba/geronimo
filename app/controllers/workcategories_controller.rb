class WorkcategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@workcategories = current_user.workcategories.all
#    @newcategory = current_user.workcategories.build if signed_in?
    @workcategory = Workcategory.new
  end

  def show
    @workcategory = current_user.workcategories.find(params[:id])
    @works = @workcategory.works
  end

  def create
    @workcategory = current_user.workcategories.build(params[:workcategory])
    if @workcategory.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_after_create_update
    else
      flash[:error] = "There was a problem with the work category you tried to create. It was not created."
      render_after_create_update
    end
  end

  def edit
    @category = current_user.workcategories.find_by_id(params[:id])
  end

  def update
    if current_user.workcategories.find_by_id(params[:id]).update_attributes(params[:workcategory])
      redirect_after_create_update
    else
      render 'edit'
    end
  end

  def destroy
    current_user.workcategories.find_by_id(params[:id]).destroy
    redirect_to workcategories_path
  end

  def redirect_after_create_update
    if current_user.works.any?
      redirect_to workcategories_url
    else 
      redirect_to works_url
    end
  end

  def render_after_create_update
    @workcategories = current_user.workcategories.all
    @worksubcategories = current_user.worksubcategories.all
    @works = current_user.works.all
    @worksubcategory = Worksubcategory.new
    @work = Work.new
    if current_user.works.any?
      render 'index'
    else 
      render 'works/index'
    end
  end
end
