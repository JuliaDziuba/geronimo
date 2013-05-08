class WorksubcategoriesController < ApplicationController
  before_filter :signed_in_user

  def show
    @workcategory = current_user.workcategories.find(params[:workcategory_id])
    @worksubcategory = current_user.worksubcategories.find(params[:id])
    @works = @worksubcategory.works
  end

  def new
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = Worksubcategory.new
  end

  def create
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = @category.worksubcategories.build(params[:worksubcategory])
    if @subcategory.save
      redirect_to workcategories_url
    else
      render 'new'
    end
  end

  def edit
    @category = current_user.workcategories.find(params[:workcategory_id])
    @subcategory = @workcategory.worksubcategories.find_by_id(params[:id])
  end

  def update
     @category = current_user.workcategories.find(params[:workcategory_id])
    if @category.worksubcategories.find_by_id(params[:id]).update_attributes(params[:worksubcategory])
      redirect_to workcategories_url
    else
      render 'edit'
    end
  end

  def destroy
    current_user.worksubcategories.find_by_id(params[:id]).destroy
    redirect_to workcategories_path
  end
end
