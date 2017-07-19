defmodule Verily.Mailer do

  use Bamboo.Mailer, otp_app: :verily
  import Bamboo.Email

  def login do
    new_email(
      from: "verily@example.com",
      to: "john@example.com",
      subject: "Login with Verily",
      html_body: "<strong>Welcome</strong>",
      text_body: "welcome"
    )
  end
end
