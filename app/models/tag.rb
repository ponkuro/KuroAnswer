class Tag < ActiveRecord::Base
  has_many :tagnotes, dependent: :destroy
  has_many :questions, through: :tagnotes
  
  def self.set_or_create(target_name)
    tag = Tag.find_by(name: target_name)
    
    #該当するタグが存在しなければ新規登録
    unless tag
      tag = Tag.new(name: target_name)
      tag.save
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    tag
  end
  
end