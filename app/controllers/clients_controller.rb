class ClientsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, except: [:create, :index]
  
  def create
  	@client = current_user.clients.build(params[:client])
    if @client.save
      flash[:success] = "Your new client has been created!"
      redirect_to clients_path
    else
      flash[:error] = "There was an error with the new venue. Please click 'new' to see the issue."
      @clients = current_user.clients.all_known
      render 'index'
    end
  end

  def update
  	@client = current_user.clients.find_by_munged_name(params[:id]) 
    @client.assign_attributes(params[:client])
    if @client.valid?
      @client.save
      flash[:success] = "The client has been updated!"
      redirect_to client_path(@client)
    else
      flash[:error] = "There was a problem with the changes made to the client. Please click edit to view error and correct."
      @activities = @client.activities.all
      @activity = current_user.activities.build(:client_id => @client.id)
      @activitycategories = Activitycategory.for_clients.all
      @works  = current_user.works.all
      @venues = current_user.venues.all
      @clients = []
      @clients.push(@client)
      render 'show'
    end
  end

  def show
  	@client = current_user.clients.find_by_munged_name(params[:id])
    @activities = @client.activities.all
    @activity = current_user.activities.build(:client_id => @client.id)
    @activitycategories = Activitycategory.for_clients.all
    @works  = current_user.works.all
    @venues = current_user.venues.all
    @clients = []
    @clients.push(@client)
    
  end

  def index
  	@clients = current_user.clients.all_known
    @client = current_user.clients.build
  end

  def destroy
    @client = current_user.clients.find_by_munged_name(params[:id])
    @activities = @client.activities.all
    if @activities.any?
      @activities.each do |activity|
        activity.update_attributes(:client_id => nil)
      end
    end
    @client.destroy
    redirect_to clients_path
  end

  private

    def correct_user
      @client = current_user.clients.find_by_munged_name(params[:id])
      if @client.nil?
        flash[:error] = "Sorry that client does not belong to you!"
        redirect_to clients_path
      end
    end
  
end
