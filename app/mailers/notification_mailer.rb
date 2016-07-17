class NotificationMailer < ApplicationMailer
  default from: "pon.kurose.test@gmail.com"

  def post_notice_email(question)
    @user = question.user
    sitename = ENV["SITE_NAME"]
    mail to: @user.email, subject: "【#{sitename}】質問への回答がありました。"
  end
end