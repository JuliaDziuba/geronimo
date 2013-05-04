class WorksController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@works = current_user.works.all
  end

  def show
    @work = current_user.works.find(params[:id])
  end

  def new
  	@work = current_user.works.build if signed_in?
    @workcategories = current_user.workcategories.all
    @worksubcategories = current_user.worksubcategories.all
  end

  def create
    @work = current_user.works.build(params[:work])
    if @work.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to works_path
    else
      render 'new'
    end
  end

  def edit
    @work = current_user.works.find_by_id(params[:id])
  end

  def update
    if current_user.works.find_by_id(params[:id]).update_attributes(params[:work])
      redirect_to works_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.works.find_by_id(params[:id]).destroy
    redirect_to works_path
  end

  private

    def correct_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to works_path if @work.nil?
    end
end

