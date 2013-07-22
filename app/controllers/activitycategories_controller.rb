class ActivitycategoriesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user

  def create
    @category = Activitycategory.new(params[:activitycategory])
    if @category.save
      # flash[:success] = "Your new category of activities is created! Add some activities to it!"
      redirect_to activitycategories_path
    else
      render 'index'
    end
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
