class SitevenuesController < ApplicationController

  def create
    @site = current_user.sites.find(params[:site_id])
    @sitevenue = @site.sitevenues.build(params[:sitevenue])
    if @sitevenue.save
      flash[:success] = "New works have been added to your site!"
      redirect_to site_url(@site)
    else
      flash[:failure] = "Your selection of works failed."
      redirect_to site_url(@site)
    end
  end

  def index
    @site = current_user.sites.find_by_id(params[:site_id])
    @sitevenue = Sitevenue.new
    @selected = @site.venues.all
    @unselected = current_user.venues.all
  end

  def destroy
  	@site = current_user.sitevenues.find_by_id(params[:id]).site
		current_user.sitevenues.find_by_id(params[:id]).destroy
    redirect_to site_url(@site)
  end
end
