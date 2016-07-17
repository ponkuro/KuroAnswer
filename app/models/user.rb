class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  mount_uploader :image, ImageUploader
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  
  ######################################
  ##  ユーザー認証に関連したメソッド  ##
  ######################################
  
  # UUID(Universally Unique Identifier)を生成
  def self.create_unique_string 
    SecureRandom.uuid 
  end

  # ユニークなEmailを自動生成 <-- Twitter認証時に使用
  def self.create_unique_email 
    User.create_unique_string + "@example.com" 
  end

  # facebook認証時の処理
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil) 
    user = User.where(provider: auth.provider, uid: auth.uid).first
    
    # データベースに該当ユーザーが存在しない場合 <-- 新規登録時
    unless user 
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: User.create_unique_email,
        password: Devise.friendly_token[0,20]
      )
      
      user.remote_image_url = "https://graph.facebook.com/#{user.uid}/picture?width=120&height=120"
      user.skip_confirmation!
      user.save(:validate => false)
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    user
    
  end

  # twitter認証時の処理
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil) 
    user = User.where(provider: auth.provider, uid: auth.uid).first
    
    # データベースに該当ユーザーが存在しない場合 <-- 新規登録時
    unless user 
      user = User.new(
        name: auth.info.nickname,
        provider: auth.provider,
        uid: auth.uid,
        email: User.create_unique_email,
        password: Devise.friendly_token[0,20]
      )
      
      user.remote_image_url = "http://furyu.nazo.cc/twicon/#{user.name}/original"
      user.skip_confirmation!
      user.save(:validate => false)
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    user
    
  end

end
