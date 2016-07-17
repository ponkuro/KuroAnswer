class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = Tag.order(frequency: :desc, updated_at: :desc).page(params[:page])
  end
  
  def show
    @tag = Tag.find(params[:id])
    @questions = @tag.questions.order(created_at: :desc).page(params[:page])
    @answers = []
    @answer = []
    @questions.each do |question|
      @answers[question.id] = question.answers
      @answer[question.id] = question.answers.build
    end
  end

  def search
    @tag = Tag.find_by(name: params[:tag_name])
    unless @tag
      respond_to do |format|
        format.html { redirect_to tags_url, notice: 'お探しのタグは見つかりませんでした。' }
      end
    else
      @questions = @tag.questions.order(created_at: :desc).page(params[:page])
      @answers = []
      @answer = []
      @questions.each do |question|
        @answers[question.id] = question.answers
        @answer[question.id] = question.answers.build
      end
      respond_to do |format|
        format.html { render :show }
      end
    end
  end
  
  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to :back }
      else
        format.html { render :back }
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def editstart
    @question = Question.find(params[:id])
    respond_to do |format|
      format.js {render :edit_start }
    end
  end

  def editend
    @question = Question.find(params[:id])
    respond_to do |format|
      format.js {render :edit_end }
    end
  end
  
  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end