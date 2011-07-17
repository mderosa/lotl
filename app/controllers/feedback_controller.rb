class FeedbackController < ApplicationController
  skip_before_filter :authenticate

  def new
  end

  def create
    AdminMailer.feedback_note(params).deliver
    redirect_to home_path
  end

end
