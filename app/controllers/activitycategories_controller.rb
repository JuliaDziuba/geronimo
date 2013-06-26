class ActivitycategoriesController < ApplicationController
  before_filter :signed_in_user
  
  def index
  	@activitycategories = Activitycategory.all
    @category = Activitycategory.new
  end

  def show
    @category = Activitycategory.find(params[:id])
    @activities = @category.activities
  end

  def new
    @category = Activitycategory.new
  end

  def create
    @category = Activitycategory.new(params[:activitycategory])
    if @category.save
      # flash[:success] = "Your new category of activities is created! Add some activities to it!"
      redirect_to activitycategories_path
    else
      render 'index'
    end
  end

  def edit
    @category = Activitycategory.find_by_id(params[:id])
  end

  def update
    if Activitycategory.find_by_id(params[:id]).update_attributes(params[:activitycategory])
      redirect_to activitycategories_path
    else
      render 'edit'
    end
  end

  def destroy
    Activitycategory.find_by_id(params[:id]).destroy
    redirect_to activitycategories_path
  end
end
