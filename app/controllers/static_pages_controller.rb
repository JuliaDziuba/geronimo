class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		redirect_to user_url(current_user)
  	else
      render :layout => 'landing'
  	end
  end

  def about
  end

  def contact
  end
end
