class ClientsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, except: [:new, :create, :index]
  
  def new
    @client = Client.new
  end

  def create
  	@client = current_user.clients.build(params[:client])
    if @client.save
      flash[:success] = "Your new client has been created!"
      redirect_to clients_path
    else
      render 'new'
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
      @activities = @client.activities.all
      render 'show'
    end
  end

  def show
  	@client = current_user.clients.find_by_munged_name(params[:id])
    @activities = @client.activities.all    
  end

  def index
    @client = Client.new
  	@clients = current_user.clients.all_known
    respond_to do |format|
      format.html
      format.csv { send_data Client.to_csv(@clients) }
    end    
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
