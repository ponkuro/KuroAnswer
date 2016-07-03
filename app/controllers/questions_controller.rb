class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :correct_user_question, only: [:edit, :update, :destroy]
  
  def index
    @questions = Question.order(created_at: :desc).page(params[:page])
    @answers = []
    @answer = []
    @questions.each do |question|
      @answers[question.id] = question.answers
      @answer[question.id] = question.answers.build
    end
  end
  
  def show
    @answers = @question.answers
    @answer = @question.answers.build
    @recent_questions = Question.where(category: @question.category).order(created_at: :desc).limit(10)
    if @recent_questions.empty?
      @recent_questions = Question.order(created_at: :desc).limit(10)
    end
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(question_params)
    correct_user_question
    respond_to do |format|
      if @question.save
        format.html { redirect_to user_url(@question.user_id) }
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to user_url(@question.user_id) }
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to user_url(@question.user_id) }
    end
  end
  
  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :content, :user_id )
    end
    
    def correct_user_question
      redirect_to(root_url) unless @question.user_id == current_user.id
    end
end