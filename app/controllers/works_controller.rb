class WorksController < ApplicationController
  before_filter :signed_in_user  
  # before_filter :correct_user,   only: :destroy

  def index
  	@works = current_user.works.all
  end

  def show
    @work = current_user.works.find(params[:id])
  end

  def new
  	@work = Work.new
    @worksubcategories = subcategories
  end

  def create
    @work = Work.new(params[:work])
    if @work.save
      # flash[:success] = "Your new type of works created! Add some works to it!"
      redirect_to works_path
    else
      render 'new'
    end
  end

  def edit
    @work = current_user.works.find_by_id(params[:id])
    @worksubcategories = subcategories
  end

  def update
    if Work.find_by_id(params[:id]).update_attributes(params[:work])
      redirect_to works_path
    else
      render 'edit'
    end
  end

  def destroy
    current_user.works.find_by_id(params[:id]).destroy
    redirect_to works_path
  end

  private

    def correct_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to works_path if @work.nil?
    end

    def subcategories
      @worksubcategories = current_user.worksubcategories
      @worksubcategories.each do |worksubcategory|
        worksubcategory[:name] = worksubcategory.workcategory.name + " > " + worksubcategory.name
      end
    end

end

