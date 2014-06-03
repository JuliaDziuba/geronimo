class StaticPagesController < ApplicationController
  before_filter :signed_in_user, except: [:home, :features, :pricing, :sitemap]

  def home
  	if signed_in?
      flash.keep
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

  def sitemap
    @users = User.shared_publicly.all
    @works = Work.shared_with_public.limit(100).order('works.updated_at DESC').all(:include =>  [:workcategory, :user])
  end

end
