class ClientsController < ApplicationController
  before_filter :signed_in_user
  
  def create
  	@client = current_user.clients.build(params[:client])
    if @client.save
      # flash[:success] = "Your new client is created!""
      redirect_to clients_path
    else
      render 'index'
    end
  end

  def update
  	@client = current_user.clients.find_by_munged_name(params[:id]) 
    if @client.update_attributes(params[:client])
      redirect_to client_path(@client)
    else
      render 'show'
    end
  end

  def show
  	@client = current_user.clients.find_by_munged_name(params[:id])
    @activities = @client.activities.all
    
  end

  def index
  	@clients = current_user.clients.all_known
    @client = current_user.clients.build if signed_in?
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
  
end
