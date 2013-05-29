class SitevenuesController < ApplicationController

  def create
    @site = current_user.sites.find_by_id(params[:site_id])
    @venuesBefore = @site.venues.count
    @num = params[:times].to_i
    @num.times do |i|
      @sitevenue = :sitevenue[i]
      @site.sitevenues.create(params[@sitevenue])
    end
    @venuesAdded = @site.venues.count - @venuesBefore
    if @venuesAdded > 0
      flash[:success] = "You've added #{@venuesAdded} venues to your site!"
      redirect_to site_url(@site)
    else
      flash[:failure] = "Your selection of venues failed. No venues were added to your site."
      redirect_to site_url(@site)
    end
  end

  def index
    @site = current_user.sites.find_by_id(params[:site_id])
    @sitevenue = Sitevenue.new
    @selected = @site.venues.all
    @unselected = current_user.venues.not_on_site(@site)
  end

  def destroy
  	@site = current_user.sitevenues.find_by_id(params[:id]).site
		current_user.sitevenues.find_by_id(params[:id]).destroy
    redirect_to site_url(@site)
  end
end
