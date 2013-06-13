class WorkcategoriesController < ApplicationController
  before_filter :signed_in_user
  # before_filter :correct_user,   only: :destroy

  def index
  	@parentcategories = current_user.workcategories.parents_only
    @workcategory = Workcategory.new
  end

  def show
    @parentcategories = current_user.workcategories.parents_only
    @workcategory = current_user.workcategories.find(params[:id])
    @works = @workcategory.works
  end

  def create
    @workcategory = current_user.workcategories.build(params[:workcategory])
    if @workcategory.save
      # flash[:success] = "Your new category of works created! Add some works to it!"
      redirect_to workcategories_url
    else
      @parentcategories = current_user.workcategories.parents_only
      flash[:error] = "There was a problem with the work category you tried to create. It was not created."
      render 'index'
    end
  end

  def edit
    @workcategory = current_user.workcategories.find_by_id(params[:id])
    # change line below to exclude @category.
    if @workcategory.children.any?
      @parentcategories = []
    else
      @parentcategories = current_user.workcategories.parents_only.excluding(@workcategory) 
    end
    
  end

  def update
    @workcategory = current_user.workcategories.find_by_id(params[:id])
    if @workcategory.update_attributes(params[:workcategory])
      redirect_to workcategories_url
    else
      render 'edit'
    end
  end

  def destroy
    @workcategory = current_user.workcategories.find_by_id(params[:id])
    @children = @workcategory.children
    @works = @workcategory.works.all
    if @children.any?  
      @children.each do |child|
        child.update_attributes(:parent_id => nil)
      end
    end
    if @works.any?
      @works.each do |work|
        work.update_attributes(:workcategory_id => nil)
      end
    end

    @workcategory.destroy
    redirect_to workcategories_path
  end

end
