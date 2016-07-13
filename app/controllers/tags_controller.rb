class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = Tag.order(created_at: :desc).page(params[:page])
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