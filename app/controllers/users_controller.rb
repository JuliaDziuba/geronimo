class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :index, :edit, :update, :destroy, :public]
  before_filter :correct_user,   only: [:show, :edit, :update, :public]
  before_filter :admin_user,     only: [:destroy]
  
  def annual
    @year = params[:year].to_i || Date.today.year
    @user = User.find_by_username(params[:id])
    sold_works = getSoldWorks(@user)
    @sold_works_array = salesInYear(sold_works, @year)
    by_category = convertSalesHOAtoHOAAForYear(getSoldWorksByCategory(sold_works), @year)
    @sold_works_by_category_array = reduceToCurrentYear(by_category)
    @sold_works_by_category_to_date = reduceToToDate(by_category)
    by_venue = convertSalesHOAtoHOAAForYear(getSoldWorksByOutcome(@user, "venue"), @year)
    @sold_works_by_venue_array = reduceToCurrentYear(by_venue)
    @sold_works_by_venue_to_date = reduceToToDate(by_venue)
    by_client = convertSalesHOAtoHOAAForYear(getSoldWorksByOutcome(@user, "client"), @year)
    @sold_works_by_client_array = reduceToCurrentYear(by_client)
    @sold_works_by_client_to_date = reduceToToDate(by_client)
    @date_of_oldest_work = dateOfOldestWork(@user)
  end


  def insight
    @user = User.find_by_username(params[:id])
    @current_activities = @user.work_current_activities
    @sold_works = getSoldWorks(@user)
    @date_of_oldest_work = dateOfOldestWork(@user)
  end

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
        @workcategory = @user.workcategories.find_by_name(params[:workcategory])
        @works = @user.works.shared_with_public.in_category(@workcategory)
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

  def account
    @user = User.find_by_username(params[:id])
    @tier = @user.tier
  end

  def show
    @user = User.find_by_username(params[:id])
    @workcategories = @user.workcategories
    @works = @user.works
    @actions = Action.all_for_users(current_user.id);
    @notes = Note.all_for_users(current_user.id);
  end

  def index
    @users = User.shared_publicly.all
    @works = Work.shared_with_public.limit(100).order('works.updated_at DESC').all(:include =>  [:workcategory, :user])
  end

  def new
  	@user = User.new
    render :layout => 'landing'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user
      @user.venues.create!(name: "My Studio", venuecategory_id: Venuecategory.find_by_name("Studios").id)
    else
      render 'new', :layout => 'landing'
    end
  end

  def edit
  end

  def update
    referer_public = params[:user] && params[:user][:share_with_public]
    if @user.update_attributes(params[:user])
      sign_in @user
      if referer_public
        flash[:success] = "Your public profile has been updated!"
        redirect_to public_user_path(@user)
      else
        flash[:success] = "Your profile was updated!"
        redirect_to @user
      end
    else
      if referer_public
        render 'public'
      else
        render 'edit'
      end
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
      if signed_in?
        redirect_to signin_path unless current_user.admin?
      else 
        redirect_to root_url
      end
    end

    def work_categories
      current_user.workcategories.all
    end

    def works
      current_user.works.all
    end

    def getSoldWorks(user)
      sold_works = []
      sale_activities = user.activities.sales.all
      sale_activities.each do | sale |
        work = user.works.where('works.id = ?', sale.work_id).first.attributes
        work["retail"] = sale.retail
        work["income"] = sale.income
        work["sale_date"] = sale.date_start
        sold_works.push(work)
      end
      sold_works
    end

    def getSoldWorksByOutcome(user, outcome)
      hoa = {}
      sale_activities = user.activities.sales.all
      sale_activities.each do | sale |
        work = user.works.where('works.id = ?', sale.work_id).first.attributes
        work["retail"] = sale.retail
        work["income"] = sale.income
        work["sale_date"] = sale.date_start
        key = "Unknown"
        if outcome == "venue" 
          venue = user.venues.find(sale.venue_id)
          key = venue["name"]
        elsif outcome == "client"
          if sale.client_id.nil?
            key = "Unknown"
          else
            client = user.clients.find(sale.client_id)
            key = client["name"]
          end
        end
        if hoa.has_key? key
          hoa[key].push work 
        else 
          hoa[key] = []
          hoa[key].push work 
        end
      end
      hoa
    end

    def getSoldWorksByCategory(works)
      hoa = {}
      works.each do | w |
        id = Workcategory.find(w["workcategory_id"]).name
        if hoa.has_key? id
          hoa[id].push w
        else
          hoa[id] = []
          hoa[id].push w
        end
      end
      hoa
    end

    def salesInYear(works, year)
      q1 = []
      q2 = []
      q3 = []
      q4 = []
      all = []
      todate = []
      works.each do |w|
        if w["sale_date"] < Date.parse("#{year + 1}-#{GlobalConstants::Q1_START}")
          if w["sale_date"] >= Date.parse("#{year}-#{GlobalConstants::Q4_START}")
            q4.push w 
          elsif w["sale_date"] >= Date.parse("#{year}-#{GlobalConstants::Q3_START}")  
            q3.push w
          elsif w["sale_date"] >= Date.parse("#{year}-#{GlobalConstants::Q2_START}")  
            q2.push w
          elsif w["sale_date"] >= Date.parse("#{year}-#{GlobalConstants::Q1_START}")  
            q1.push w
          end
          if w["sale_date"] >= Date.parse("#{year}-#{GlobalConstants::Q1_START}") 
            all.push w 
          end
          todate.push w
        end 
      end
      [q1, q2, q3, q4, all, todate]
    end

    def convertSalesHOAtoHOAAForYear(hoa, year)
      hoaa = {}
      hoa.each do | k, a | 
        hoaa[k] = salesInYear(a, year)
      end
      hoaa
    end

    def reduceToCurrentYear(hoaa)
      reduced = {}
      hoaa.each do | k, a |
        reduced[k] = [a[0], a[1], a[2], a[3], a[4]] if not a[4].count == 0
      end
      reduced
    end

    def reduceToToDate(hoaa)
      reduced = {}
      hoaa.each do | k, a |
        reduced[k] = a[5]
      end
      reduced
    end

    def dateOfOldestWork(user)
      oldest_work = user.works.last
      if oldest_work.nil?
        date = Date.today
      else
        date = oldest_work.creation_date
      end
      date
    end

end
