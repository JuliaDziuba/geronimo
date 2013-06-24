class QuestionsController < ApplicationController
  before_filter :signed_in_user, only: [:create]  

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save
      flash[:success] = "Thank you for submitting your question. Expect an email within a couple of days."
      redirect_to help_path
    else
      flash[:error] = "Sorry there was a problem with the question you submitted."
      redirect_to help_path
    end
  end

end
