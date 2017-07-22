defmodule Verily.Mailer do

  use Bamboo.Mailer, otp_app: :verily
  import Bamboo.Email

  @verily_email "Verily <verily@example.com>"

  def email_for(email) do
    new_email(to: email, from: @verily_email)
  end

  def verify_email(email, token) do
    url = "/confirm/#{token}"
    email
    |> subject("Verily: Confirm your email address")
    |> html_body(~s[<a href="#{url}">CLICK HERE</a>])
    |> text_body(~s[Open this url #{url}])
  end
end
