class ImportsController < ApplicationController
  def new
    @import = Import.new
  end

  def create
    @import = Import.new(params[:import])
    if @import.save
      flash[:success] = "Imported products successfully."
      redirect_to new_import_url
    else
      flash[:error] = "The upload of #{ params[:import][:model] } was not successful. No records were updated or added. Please correct the errors and try again!"
      render 'new'
    end
  end

  def index
    redirect_to new_import_url
  end
end

