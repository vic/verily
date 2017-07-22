defmodule Verily.Verify do

  alias Verily.{Mailer, Verifier}

  def verify_email(verify_data = %{email: email}, device) do
    token = Verifier.spawn(device, verify_data)

    email
    |> Mailer.email_for
    |> Mailer.verify_email(token)
    |> Mailer.deliver_now
    {:ok, token}
  end

end
