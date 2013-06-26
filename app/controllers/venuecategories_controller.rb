class VenuecategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def create
    @category = Venuecategory.new(params[:venuecategory])
    if @category.save
      # flash[:success] = "Your new category of venues is created! Add some venues to it!"
      redirect_to venuecategories_path
    else
      render 'index'
    end
  end

  def update
    if Venuecategory.find_by_id(params[:id]).update_attributes(params[:venuecategory])
      redirect_to venuecategories_path
    else
      render 'edit'
    end
  end

  def destroy
    Venuecategory.find_by_id(params[:id]).destroy
    redirect_to sitevenues_path
  end
end
