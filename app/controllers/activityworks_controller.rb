class ActivityworksController < ApplicationController

  def new
    @activitywork = Activitywork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activitywork }
    end
  end

  def update_multiple
    @activityworks = Activitywork.update( params[:activityworks].keys, params[:activityworks].values).reject { |w| w.errors.empty? }
    if @activityworks.empty?
      flash[:notice] = "Works have been updated!"
      redirect_to works_url
    else
      @statusfilter = "failed update"
      @parentcategories = current_user.workcategories.parents_only.order_name.all
      @workcategories = current_user.workcategories_showing_families
      @workcategory = Workcategory.new
      @work = Work.new
      render :action => "index"
    end
  end

  def destroy
    @activitywork = Activitywork.find(params[:id])
    @activitywork.destroy

    respond_to do |format|
      format.html { redirect_to activityworks_url }
      format.json { head :no_content }
    end
  end
end
