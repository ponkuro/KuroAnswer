class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  paginates_per 5
end
