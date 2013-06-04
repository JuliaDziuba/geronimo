class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:show, :edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def show
    @user = User.find(params[:id])
    @workcategories = @user.workcategories
    @works = @user.works
  end

  def new
  	@user = User.new
    render :layout => 'landing'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Geronimo! Add more information about yourself to fill out your website or add works, clients and venues to start building your database!"
      redirect_to @user
      @user.venuecategories.create!(name: "Galleries", description: "Galleries with shows and permanent exhibits.")
      @user.venuecategories.create!(name: "Stores", description: "Physical locations such as boutiques, shops, salons, etc that are not galleries.")
      @user.venuecategories.create!(name: "Studios", description: "Studios work can be shown in or sold from.")
      @user.venuecategories.create!(name: "Booths", description: "Temporary venues such as white-tents or booths at conventions, fairs, or open air markets.")
      @user.venuecategories.create!(name: "Online", description: "Online venues such as Etsy or Ebay stores.")
      @user.venues.create!(name: 'Storage')
      @user.activitycategories.create!(name: "Sale", status: "Sold", final:true, description: "Sale of a work.")
      @user.activitycategories.create!(name: "Commission", status: "Commissioned", final: false, description: "Commission of work started, sale to follow.")
      @user.activitycategories.create!(name: "Consign", status: "Consigned", final: false, description: "Consignment of a work, hoping sale follows.")
      @user.activitycategories.create!(name: "Gift", status: "Gifted", final: true, description: "Gift a work.")
      @user.activitycategories.create!(name: "Donate", status: "Donated", final: true, description: "Donate a work.")
      @user.activitycategories.create!(name: "Recycle", status: "Recycled", final: true, description: "Recycle a work to create improved visions.")
      @user.clients.create!(name: "Unknown")
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Settings updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
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
