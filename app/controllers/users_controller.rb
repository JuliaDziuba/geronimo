class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Geronimo! Add more information about yourself to fill out your website or add works, clients and venues to start building your database!"
      redirect_to @user
    else
      render 'new'
    end
  end
end
