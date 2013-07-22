class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :index, :edit, :update, :destroy, :public]
  before_filter :correct_user,   only: [:show, :edit, :update, :public]
  before_filter :admin_user,     only: :destroy
  
  def about
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_about
        render :layout => 'site'
      else 
        flash[:warning] = "Sorry but #{@user.name} does not have a public page about them powered by Makers' Moon."
        redirect_to root_url
      end
    else 
      flash[:warning] = "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
      redirect_to root_url
    end
  end

  def contact
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_contact
        render :layout => 'site'
      else 
        flash[:warning] = "Sorry but #{@user.name} does not have a public contact page powered by Makers' Moon."
        redirect_to root_url
      end
    else 
      flash[:warning] = "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
      redirect_to root_url
    end
  end

  def purchase
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_purchase
        render :layout => 'site'
      else 
        flash[:warning] = "Sorry but #{@user.name} does not have a public page about purchasing powered by Makers' Moon."
        redirect_to root_url
      end
    else 
      flash[:warning] = "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
      redirect_to root_url
    end
  end

  def work
    @user = User.find_by_username(params[:user])
    if @user.share_with_public
      if @user.share_works
        @category = @user.workcategories.find_by_name(params[:workcategory])
        @works = @user.works.shared_with_public.in_category(@category)
        @work =  @user.works.find_by_inventory_id(params[:work]) || @works.first
        render :layout => 'site'
      else
        flash[:warning] = "Sorry but #{@user.name} does not have a public page to promote their works powered by Makers' Moon."
        redirect_to root_url
      end
    else
      flash[:warning] = "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
      redirect_to root_url
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    @workcategories = @user.workcategories
    @works = @user.works
  end

  def index
    @users = User.all
  end

  def new
  	@user = User.new
    render :layout => 'landing'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Makers' Moon! Add more information about yourself to fill out your website or add works, clients and venues to start building your database!"
      redirect_to @user
      @user.venues.create!(name: "My Studio", venuecategory_id: Venuecategory.find_by_name("Studios").id)
    else
      render 'new', :layout => 'landing'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Your profile was updated!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find_by_username(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def public
    @user = User.find_by_username(params[:id])
    @workcategories = @user.workcategories
    @works = @user.works
    @venues = @user.venues
  end

  private

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to signin_path unless current_user? @user
    end

    def admin_user
      redirect_to signin_path unless current_user.admin?
    end

    def work_categories
      current_user.workcategories.all
    end

    def works
      current_user.works.all
    end

end
