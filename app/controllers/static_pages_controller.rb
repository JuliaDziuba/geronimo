class StaticPagesController < ApplicationController
  before_filter :signed_in_user, except: [:home, :features, :pricing]

  def home
  	if signed_in?
  		redirect_to user_url(current_user)
  	else
      @user = User.new
      render :layout => 'landing'
  	end
  end

  def tour
    @venuecategories = Venuecategory.all
  end

  def features
    render :layout => 'landing'
  end

  def pricing
    @user = User.new
    render :layout => 'landing'
  end

  def help
    @question = current_user.questions.build()
  end

end
