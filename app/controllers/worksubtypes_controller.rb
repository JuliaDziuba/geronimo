class WorksubtypesController < ApplicationController
  before_filter :signed_in_user

  def create
    @worksubtype = current_user.worktype.worksubtypes.build(params[:worksubtype])
    if @worktype.save
      redirect_to worktypes_path
    else
      render 'new'
    end
  end
end
