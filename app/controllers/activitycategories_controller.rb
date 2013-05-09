class ActivitycategoriesController < ApplicationController
  before_filter :signed_in_user
  
  def index
  	@activitycategories = current_user.activitycategories.all
    @category = Activitycategory.new
  end

  def show
    @category = current_user.activitycategories.find(params[:id])
    @activities = @category.activities
  end

  def new
    @category = Activitycategory.new
  end

  def create
    @category = current_user.activitycategories.build(params[:activitycategory])
    if @category.save
      # flash[:success] = "Your new category of activities is created! Add some activities to it!"
      redirect_to activitycategories_path
    else
      render 'index'
    end
  end

  def edit
    @category = current_user.activitycategories.find_by_id(params[:id])
  end

  def update
    if current_user.activitycategories.find_by_id(params[:id]).update_attributes(params[:activitycategory])
      redirect_to activitycategories_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.activitycategories.find_by_id(params[:id]).destroy
    redirect_to activitycategories_path
  end
end
