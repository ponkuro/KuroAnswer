class TagnotesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find(params[:tagnote][:question_id])
    @tag = Tag.set_or_create(params[:tagnote][:tag_name])
    @question.tagging!(@tag)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {render :redraw }
    end
  end

  def destroy
    @question = Tagnote.find(params[:id]).question
    @tag = Tagnote.find(params[:id]).tag
    @question.untagging!(@tag)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {render :redraw }
    end
  end
  
end