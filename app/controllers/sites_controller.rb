class SitesController < ApplicationController
  def new
  	@site = Site.new
    @venues = current_user.venues.all
    @works = current_user.works.all
  end

  def create
    @site = current_user.sites.build(params[:site])
    if @site.save
      # flash[:success] = "Your new site has been created!"
      redirect_to site_path(@site)
    else
      render 'new'
    end
  end

  def show
    @site = current_user.sites.find(params[:id])
    @additionalworks = current_user.works.not_on_site(@site)
    @additionalvenues = current_user.venues.not_on_site(@site)
  end

  def edit
    @site = current_user.sites.find_by_id(params[:id])
    @venues = current_user.venues.all
    @works = current_user.works.all
  end

  def update

  end

  def destroy

  end

  def about
    @site = current_user.sites.find_by_id(params[:id])
    @venues = current_user.venues.all
    render :layout => 'site'
  end

  def contact
    @site = current_user.sites.find_by_id(params[:id])
    render :layout => 'site'
  end

  def works
    @site = current_user.sites.find(params[:id])
    @category = current_user.workcategories.find_by_name(params[:workcategory])
    @works = @site.works
    render :layout => 'site'
  end
end
