class WorksubcategoriesController < ApplicationController
  before_filter :signed_in_user

  def new
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = Worksubcategory.new
  end

  def create
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = @category.worksubcategories.build(params[:worksubcategory])
    if @subcategory.save
      if current_user.works.any?
        redirect_to workcategories_url
      else 
        redirect_to works_url
      end
    else
      render 'new'
    end
  end

  def edit
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = current_user.worksubcategories.find(params[:id])
  end

  def update
     @category = current_user.workcategories.find(params[:workcategory_id])
    if @category.worksubcategories.find_by_id(params[:id]).update_attributes(params[:worksubcategory])
      if current_user.works.any?
        redirect_to workcategories_url
      else 
        redirect_to works_url
      end
    else
      render 'edit'
    end
  end

  def destroy
    current_user.worksubcategories.find_by_id(params[:id]).destroy
    redirect_to workcategories_path
  end
end
