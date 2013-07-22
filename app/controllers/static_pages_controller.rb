class StaticPagesController < ApplicationController
  before_filter :signed_in_user, except: :home  

  def home
  	if signed_in?
  		redirect_to user_url(current_user)
  	else
      render :layout => 'landing'
  	end
  end

  def help
    @question = current_user.questions.build()
  end

end
