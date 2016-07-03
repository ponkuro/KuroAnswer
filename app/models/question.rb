class Question < ActiveRecord::Base
  paginates_per 5
  belongs_to :user
  has_many :answers, dependent: :destroy
end
