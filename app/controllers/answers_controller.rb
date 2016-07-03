class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :correct_user_answer, only: [:edit, :update, :destroy]

  def create
    @answer = Answer.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_url(@answer.question_id) }
        format.js {render :redraw }
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to question_url(@answer.question_id) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to question_url(@answer.question_id) }
      format.js {render :redraw }
    end
  end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end
    
    def correct_user_answer
      redirect_to(root_url) unless @answer.user_id == current_user.id
    end
    
    def answer_params
      params.require(:answer).permit(:content, :question_id, :user_id)
    end
end