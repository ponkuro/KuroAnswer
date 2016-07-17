class PvcountsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    timescope = Time.now.strftime("%Y%m%d%H").to_i
    @pvcounts = Pvcount.where(timescope: timescope).order(pv_24hr: :desc).page(params[:page])
    @questions = []
    @pvcounts.each_with_index do |cnt, i|
      @questions[i] = cnt.question
    end
    @answers = []
    @answer = []
    @questions.each do |question|
      @answers[question.id] = question.answers
      @answer[question.id] = question.answers.build
    end
  end
end
