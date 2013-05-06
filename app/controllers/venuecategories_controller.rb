class VenuecategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@venuecategories = current_user.venuecategories.all
    @newcategory = Venuecategory.new
  end

  def show
    @venuecategory = current_user.venuecategories.find(params[:id])
    @venues = @venuecategory.venues
  end

  def new
    @venuecategory = Venuecategory.new
  end

  def create
    @newcategory = current_user.venuecategories.build(params[:newcategory])
    if @newcategory.save
      # flash[:success] = "Your new category of venues is created! Add some venues to it!"
      redirect_to venuecategories_path
    else
      render 'new'
    end
  end

  def edit
    @newcategory = current_user.venuecategories.find_by_id(params[:id])
  end

  def update
    if current_user.venuecategories.find_by_id(params[:id]).update_attributes(params[:venuecategory])
      redirect_to venuecategories_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.venuecategories.find_by_id(params[:id]).destroy
    redirect_to venuecategories_path
  end
end
