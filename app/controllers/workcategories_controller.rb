class WorkcategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@workcategories = current_user.workcategories.all
#    @newcategory = current_user.workcategories.build if signed_in?
    @category = Workcategory.new
  end

  def show
    @workcategory = current_user.workcategories.find(params[:id])
    @works = @workcategory.works
  end

  def new
    @workcategory = Workcategory.new
  end

  def create
    @category = current_user.workcategories.build(params[:workcategory])
    if @category.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to workcategories_path
    else
      render 'index'
    end
  end

  def edit
    @category = current_user.workcategories.find_by_id(params[:id])
  end

  def update
    if current_user.workcategories.find_by_id(params[:id]).update_attributes(params[:workcategory])
      redirect_to workcategories_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.workcategories.find_by_id(params[:id]).destroy
    redirect_to workcategories_path
  end
end
