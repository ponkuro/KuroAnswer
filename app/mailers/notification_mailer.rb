class NotificationMailer < ApplicationMailer
  default from: "pon.kurose.test@gmail.com"

  def post_notice_email(question)
    @user = User.find(question.user_id)
    @question = Question.find(question.id)
    sitename = ENV["SITE_NAME"]
    mail to: @user.email, subject: "【#{sitename}】質問への回答が投稿されました。"
  end
end