class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:show, :edit, :update]
  before_filter :admin_user,     only: :destroy
  
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

  private

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to(signin_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def work_categories
      current_user.workcategories.all
    end

    def works
      current_user.works.all
    end

end
