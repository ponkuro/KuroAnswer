class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]
  
  def index
    @users = User.order(updated_at: :desc).page(params[:page])
  end

  def show
    @questions = @user.questions.order(created_at: :desc).page(params[:page])
    @answers = []
    @answer = []
    @questions.each do |question|
      @answers[question.id] = question.answers
      @answer[question.id] = question.answers.build
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
