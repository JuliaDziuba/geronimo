class WorkcategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@workcategories = current_user.workcategories.all
#    @newcategory = current_user.workcategories.build if signed_in?
    @newcategory = Workcategory.new
  end

  def show
    @workcategory = current_user.workcategories.find(params[:id])
#    @worksubcategory = @workcategory.worksubcategories.build if signed_in?
  end

  def new
    @workcategory = Workcategory.new
  end

  def create
    @newcategory = current_user.workcategories.build(params[:newcategory])
    if @newcategory.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to workcategories_path
    else
      render 'index'
    end
  end

  def edit
    @newcategory = current_user.workcategories.find_by_id(params[:id])
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
