class WorksubtypesController < ApplicationController
  before_filter :signed_in_user

  def create
    @worksubcategory = current_user.workcategory.worksubcategories.build(params[:worksubcategory])
    if @workcategory.save
      redirect_to workcategories_path
    else
      render 'new'
    end
  end
end
