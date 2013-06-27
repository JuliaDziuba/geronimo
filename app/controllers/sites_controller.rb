class SitesController < ApplicationController
  def new
    if current_user.sites.count > 0
      redirect_to edit_site_path(current_user.sites.first)
    else
    	@site = Site.new
      @venues = current_user.venues.all
      @works = current_user.works.all
    end
  end

  def create
    if current_user.sites.count > 0
      flash[:error] = "Only one site can be made for each Maker!"
      redirect_to site_path(current_user.sites.first)
    else
      @site = current_user.sites.build(params[:site])
      if @site.save
        # flash[:success] = "Your new site has been created!"
        redirect_to site_path(@site)
      else
        @venues = current_user.venues.all
        @works = current_user.works.all
        render 'new'
      end
    end
  end

  def show
    @site = current_user.sites.find(params[:id])
    @additionalworks = current_user.works.not_shared_with_public
    @additionalvenues = current_user.venues.not_shared_with_public
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

  def home
    @site = current_user.sites.find_by_id(params[:id])
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
    @works = @site.works_in_category(@category).all
    @work = params[:work] || @works.first
    render :layout => 'site'
  end
end
