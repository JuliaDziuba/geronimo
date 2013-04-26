class WorkcategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@workcategories = current_user.workcategories.all
    @workcategory = current_user.workcategories.build if signed_in?
  end

  def show
    @workcategory = current_user.workcategories.find(params[:id])
  end

  def create
    @workcategory = current_user.workcategories.build(params[:workcategory])
    if @workcategory.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to workcategories_path
    else
      render 'new'
    end
  end

  def edit
    @workcategory = current_user.workcategories.find_by_id(params[:id])
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

  private

    def correct_user
      @workcategory = current_user.workcategories.find_by_id(params[:id])
      redirect_to workcategories_path if @workcategory.nil?
    end
end
