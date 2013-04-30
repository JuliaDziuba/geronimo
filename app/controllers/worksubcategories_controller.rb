class WorksubcategoriesController < ApplicationController
  before_filter :signed_in_user

  def show
    @worksubcategory = current_user.worksubcategories.find(params[:id])
    @works = @worksubcategory.works
  end

  def new
    @worksubcategory = Worksubcategory.new
  end

  def create
    @worksubcategory = current_user.worksubcategories.build(params[:worksubcategory])
    if @worksubcategory.save
      redirect_to workcategory_path
    else
      render 'new'
    end
  end

  def edit
    @worksubcategory = current_user.worksubcategories.find_by_id(params[:id])
  end

  def update
    if current_user.worksubcategories.find_by_id(params[:id]).update_attributes(params[:worksubcategory])
      redirect_to workcategories_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.worksubcategories.find_by_id(params[:id]).destroy
    redirect_to workcategories_path
  end
end
