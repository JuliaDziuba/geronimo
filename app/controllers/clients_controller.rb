class ClientsController < ApplicationController
  before_filter :signed_in_user
  
  def create
  	@client = current_user.clients.build(params[:client])
    if @client.save
      # flash[:success] = "Your new client is created!""
      redirect_to client_path(@client)
    else
      render 'new'
    end
  end

  def update
  	@client = current_user.clients.find_by_id(params[:id]) 
    if @client.update_attributes(params[:client])
      redirect_to client_path(@client)
    else
      render 'edit'
    end
  end

  def show
  	@client = current_user.clients.find_by_id(params[:id])
    @activities = @client.activities.all
    
  end

  def index
  	@clients = current_user.clients.all
    @client = current_user.clients.build if signed_in?
  end

  def destroy
  	current_user.clients.find_by_id(params[:id]).destroy
    redirect_to clients_path
  end
  
end
