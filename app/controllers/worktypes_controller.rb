class WorktypesController < ApplicationController
  before_filter :signed_in_user

  def index
  	@worktypes = current_user.worktypes.all
    @worktype = current_user.worktypes.build if signed_in?
  end

  def show
  # I may have to pass it too parms. I'm not really sure. There might be something on this in ch. 10 or 11
  # @worktype = current_user.Worktype.find(params[:id])
  end

  def create
    @worktype = current_user.worktypes.build(params[:worktype])
    if @worktype.save
      flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to worktypes_path
    else
      render 'new'
    end
  end
end
