class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update, :destroy, :public]
  before_filter :correct_user,   only: [:show, :edit, :update, :public]
  before_filter :admin_user,     only: [:destroy, :admin]
  
  def admin
    @newEntries = getNewEntriesHOA()
    @userH = Hash.new()
    User.all(:include => [:works, :clients, :venues, :activities]).each do | u |
      @userH["#{u.id} #{u.username} #{u.email}"] = [ u.works.count, u.clients.count, u.venues.count, u.activities.count]
    end
    @user = User.new
  end 

  def annual
    @year = params[:year].to_i || Date.today.year
    @user = User.find_by_username(params[:id])
    sold_works = getSoldWorksAtTime(@user, Date.parse("#{@year}-#{GlobalConstants::Q4_END}") )
    @sold_works_array = salesInYear(sold_works, @year)
    by_category = convertSalesHOAtoHOAAForYear(sortWorksByOutcome(sold_works, 'category'), @year)
    @sold_works_by_category_array = reduceToCurrentYear(by_category)
    @sold_works_by_category_to_date = reduceToToDate(by_category)
    by_venue = convertSalesHOAtoHOAAForYear(sortWorksByOutcome(sold_works, 'venue'), @year)
    @sold_works_by_venue_array = reduceToCurrentYear(by_venue)
    @sold_works_by_venue_to_date = reduceToToDate(by_venue)
    by_client = convertSalesHOAtoHOAAForYear(sortWorksByOutcome(sold_works, 'client'), @year)
    @sold_works_by_client_array = reduceToCurrentYear(by_client)
    @sold_works_by_client_to_date = reduceToToDate(by_client)
    by_work = convertSalesHOAtoHOAAForYear(sortWorksByOutcome(sold_works, 'work'), @year)
    @sold_works_by_work_array = reduceToCurrentYear(by_work)
    @sold_works_by_work_to_date = reduceToToDate(by_work)
    @date_of_oldest_work = dateOfOldestWork(@user)
  end

  def insight
    @user = User.find_by_username(params[:id])
    @date_of_oldest_work = dateOfOldestWork(@user)
    @activities_array = getActivitiesSnapShot(@user)
    @available_works_count = countAvailableWorks(@user.works.all)
    @displayed_available_works_count = @activities_array.count(Activity::CONSIGNMENT[:status]) + @activities_array.count(Activity::SHOW[:status])
    @total_works_count = @activities_array.count + @available_works_count
    @total_placed_works_count = @activities_array.count(Activity::SALE[:status]) + @activities_array.count(Activity::GIFT[:status]) + @activities_array.count(Activity::DONATION[:status])
    sold_works = getSoldWorksAtTime(@user, Date.today)
    @sold_works_array = salesSnapShot(sold_works)
    @sold_works_by_category_array = convertSalesHOAToHOAAForSnapshot(sortWorksByOutcome(sold_works, 'category'))
    @sold_works_by_venue_array = convertSalesHOAToHOAAForSnapshot(sortWorksByOutcome(sold_works,'venue'))
    @sold_works_by_client_array = convertSalesHOAToHOAAForSnapshot(sortWorksByOutcome(sold_works,'client'))
    @sold_works_by_work_array = convertSalesHOAToHOAAForSnapshot(sortWorksByOutcome(sold_works,'work'))
  end

  def countAvailableWorks(works)
    count = 0
    works.each do | work |
      count = count + work.quantity
    end
    count
  end

  def about
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_about

        @bio = Comment.find(@user.bio_id) if ! @user.bio_id.blank?
        @statement = Comment.find(@user.statement_id) if ! @user.statement_id.blank?
        render :layout => 'site'
      else 
        redirect_to root_url, alert: "Sorry but #{@user.name} does not have an 'about' page powered by Makers' Moon."
      end
    else 
      redirect_to root_url, alert: "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
    end
  end

  def contact
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_contact
        render :layout => 'site'
      else 
        redirect_to root_url, alert: "Sorry but #{@user.name} does not have a 'contact' page powered by Makers' Moon."
      end
    else 
      redirect_to root_url, alert: "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
    end
  end

  def purchase
    @user = User.find_by_username(params[:id])
    if @user.share_with_public
      if @user.share_purchase
        render :layout => 'site'
      else 
        redirect_to root_url, alert: "Sorry but #{@user.name} does not have a 'purchasing' page powered by Makers' Moon."
      end
    else 
      redirect_to root_url, alert: "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
    end
  end

  def work
    @user = User.find_by_username(params[:user])
    if @user.share_with_public
      if @user.share_works
        if params[:workcategory] == Workcategory::DEFAULT
          @workcategory = Workcategory.new(:name => Workcategory::DEFAULT)
          @works = @user.works.shared.uncategorized.order_creation_date.all
        else
          @workcategory = @user.workcategories.find_by_name(params[:workcategory])
          @works = @user.works.shared.in_category(@workcategory).order_creation_date
        end
        @work =  @user.works.find_by_inventory_id(params[:work]) || @works.first
        render :layout => 'site'
      else
        redirect_to root_url, alert: "Sorry but #{@user.name} does not have a public page to promote their works powered by Makers' Moon."
      end
    else
      redirect_to root_url, alert: "Sorry but #{@user.name} does not have a public site powered by Makers' Moon."
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
    @users = User.shared_publicly.order_tier.order_share_works
    @works = Work.shared.limit(100).order('works.updated_at DESC').all(:include =>  [:workcategory, :user])
    if !signed_in?
      render :layout => 'landing'
    else
      respond_to do |format|
        format.html
        format.csv { 
          send_data User.to_csv(@current_user) }
      end
    end
  end

  def new
  	@user = User.new
    render :layout => 'landing'
  end

  def create
    @user = User.find_by_username(params[:user][:username])
    if @user.nil?
      @user = User.new(params[:user]) 
    end 
    adminUpdate = current_user.admin && current_user.username != @user.username && @user.id
    if adminUpdate
      #Admin is just updating password
      if @user.update_attributes(params[:user])
        flash[:success] = "The password for " + @user.username + " has been updated!"
      else
        flash[:info] = "The password was not updated for " + @user.username + ". Try again!"
      end
      redirect_to admin_user_path(@current_user)
    else
      if @user.save
        sign_in @user
        redirect_to @user
        subscribeToMailChimp(@user)
      else
        render 'new', :layout => 'landing'
      end
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
    @bios = @user.comments.bios.all
    @statements = @user.comments.statements.all
    @bios.each do | bio | 
      bio.name = bio.name + " - " + bio.date.strftime('%m/%d/%Y')
    end
    @statements.each do | statement | 
      statement.name = statement.name + " - " + statement.date.strftime('%m/%d/%Y')
    end
  end

  private

    def subscribeToMailChimp(user)
      mc = Gibbon::API.new
      mc.lists.subscribe({:id => 'e1e4a2dd84', :email => {:email => user.email}, :merge_vars => {:FNAME => user.username}, :double_optin => false})
    end

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

    def getNewEntriesHOA()
      hoa = {}
      hoa["Users"] = getNewEntriesArray(User.all)
      hoa["Works"] = getNewEntriesArray(Work.all)
      hoa["Categories"] = getNewEntriesArray(Workcategory.all)
      hoa["Venues"] = getNewEntriesArray(Venue.all)
      hoa["Clients"] = getNewEntriesArray(Client.all)
      hoa["Activities"] = getNewEntriesArray(Activity.all)
      hoa
    end

    def getNewEntriesArray(entries)
      dates = [Date.today, 1.week.ago.to_date, 1.month.ago.to_date, 1.year.ago.to_date]
      a = [0,0,0,0,0]
      entries.each do | e | 
        dates.each_with_index do | d, i = 0 |
          if e.created_at >= d 
            a[i] = a[i] + 1
          end
        end
        a[4] = a[4] + 1 
      end
      a
    end

  def getActivitiesSnapShot(user)
    works = user.works.all(:include => :activityworks ) 
    getActivitiesForWorksAtTime(works, Date.today)
  end 

  def getActivitiesForWorksAtTime(works, date)
    activities = [] 
    works.each do | work |
      if work.creation_date <= date
        work.activityworks.each do | aw |
          if aw.activity.startingBeforeDate(date) then 
            sold_count = aw.sold 
            remaining_count = aw.quantity - sold_count
            (1..sold_count).each do |i|
              activities.push(Activity::SALE[:status])
            end
            if remaining_count > 0 then 
              (1..remaining_count).each do |i|
                category = Activity::CATEGORY_ID_OBJECT_HASH[aw.activity.category_id]
                if category[:instant]
                  activities.push(category[:status]) 
                else
                  if aw.activity.date_end.blank? || aw.activity.date_end > date then 
                    activities.push(category[:status])
                  end
                end
              end
            end
          end
        end
      end
    end
    activities
  end

  def getSoldWorksAtTime(user, time)
    sold_works = []
    sale_activities = user.activityworks.startingBeforeDate(time).sold_works.all
    sale_activities.each do | sale |
      sold_work = SoldWork.buildFromSale(sale)
      sold_works.push(sold_work)
    end
    sold_works
  end

  def sortWorksByOutcome(works, outcome)
    hoa = {}
    works.each do | w |
      if outcome == "category"
        id = w.workcategory_id
        if id.nil?
          key = "Uncategorized"
        else
          key = Workcategory.find(id).name
        end
      elsif outcome == "work"
        key = Work.find(w.work_id).title
      elsif outcome == "venue"
        key = Venue.find(w.venue_id).name
      elsif outcome == "client"
        if w.client_id.nil?
          key = "Unknown"
        else
          key = Client.find(w.client_id).name
        end
      end
      if hoa.has_key? key
        hoa[key].push w 
      else 
        hoa[key] = []
        hoa[key].push w 
      end
    end
    hoa
  end    

    def salesSnapShot(works)
      dates = [1.month.ago.to_date, 6.months.ago.to_date, 1.year.ago.to_date, 5.year.ago.to_date]
      sales = [[],[],[],[],[]]
      works.each do | w |
        dates.each_with_index do | d, i = 0 |
          if w.sale_date > d 
            sales[i].push w 
          end
        end
        sales[4].push w 
      end
      sales
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

    def convertSalesHOAToHOAAForSnapshot(hoa)
      hoaa = {}
      hoa.each do | k, a |
        hoaa[k] = salesSnapShot(a)
      end
      hoaa
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
      oldest_work = user.works.order_creation_date.last
      if oldest_work.nil?
        date = Date.today
      else
        date = oldest_work.creation_date
      end
      date
    end

end
