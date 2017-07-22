# Verily

This is a demo application to serve as an example of how to use Apollo Phoenix Websocket with Absinthe subscriptions.

Verily implements a mail authentication app, akin to Facebook AccountKit. That is, the user enters
their email and clicks on `Login`, then the application awaits (via gql subscription) for the user
to verify via a link on their inbox. The app receives the subscription data and logins the user automatically.

### Installation

```shell
$ git clone https://github.com/vic/verily.git
$ cd verily
$ mix deps.get
$ yarn install
$ mix phoenix.server
$ open http://localhost:4000/
```

### Code

The backend code is just a simple plug application that exposes a tiny GQL API with Absinthe.

Of these the most interesting one is the `viewer` subscription. It takes a `device_token` as topic 
(in my example, every client, eg mobile device or browser must generate a unique device token for
 its viewer subscription to work) 

Verification is made via an `email_login` mutation that basically generates a random verification
token (that will be sent via email) and starts a tiny process using an Elixir Registry. These 
veirfier processes live just five minutes, so that if no one confirms the email, the process
automatically dies and the token becomes invalid. When the user cliks on the link with the token,
the backend terminates the verifier process and sends the original email to the client via the
GraphQL websocket subscription.

The client code is at `web/static/js` and most of it has nothing to do with 
Apollo Phoenix Websocket, haha, the apollo client configuration
is made at `apollo.js` which also prefers to convert promises and observers into xstreams
(as I just wanted to use them for this example) the api is defined at `api.js`, the `app.js` is
where views and logic is bound together.

