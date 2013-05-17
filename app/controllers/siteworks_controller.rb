class SiteworksController < ApplicationController
  
  def create
    @site = current_user.sites.find(params[:site_id])
    @sitework = @site.siteworks.build(params[:sitework])
    if @sitework.save
      flash[:success] = "New works have been added to your site!"
      redirect_to site_url(@site)
    else
      flash[:failure] = "Your selection of works failed."
      redirect_to site_url(@site)
    end
  end

  def index
    @site = current_user.sites.find_by_id(params[:site_id])
    @sitework = Sitework.new
    @selected = @site.works.all
    @unselected = current_user.works.all
  end

  def destroy
  	@site = current_user.siteworks.find_by_id(params[:id]).site
		current_user.siteworks.find_by_id(params[:id]).destroy
    flash[:success] = "Selected works have been removed from your site!"
    redirect_to site_url(@site)
  end

end
