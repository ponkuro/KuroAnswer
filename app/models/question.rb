class Question < ActiveRecord::Base
  paginates_per 5
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :tagnotes, dependent: :destroy
  has_many :tags, through: :tagnotes
  
  ######################################
  ##  タグ機能に関連したメソッド  ##
  ######################################
  
  # 指定したtagをつける
  def tagging!(target_tag)
    tagnotes.create!(tag_id: target_tag.id)
    
    # タグの使用頻度情報を更新
    tag = Tag.find(target_tag.id)
    tag.frequency = tag.questions.count
    tag.save
  end

  # 指定したtagを解除る
  def untagging!(target_tag)
    tagnotes.find_by(tag_id: target_tag.id).destroy
    
    # タグの使用頻度情報を更新
    tag = Tag.find(target_tag.id)
    tag.frequency = tag.questions.count
    tag.save
  end
end