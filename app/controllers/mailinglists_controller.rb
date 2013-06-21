class MailinglistsController < ApplicationController
  def new
  	@mailinglist = Mailinglist.new
  	render :layout => 'mailinglist'
  end

  def create
  	@mailinglist = Mailinglist.new(params[:mailinglist])
  	if @mailinglist.save
  		 redirect_to @mailinglist
  	else
      render 'new', :layout => 'mailinglist'
    end
    
  end

  def show
    render :layout => 'mailinglist'
  end
end
