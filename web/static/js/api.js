import apollo from './apollo'
import gql from 'graphql-tag'

const hello = gql`query { hello }`

const viewer = gql`
query {
  viewer {
    name, email
  }
}
`

const emailLogin = gql`
mutation($email: String!, $device_token: String!) {
  emailLogin(email: $email, device_token: $device_token) { token }
}
`

const viewerSubscription = gql`
subscription($device_token: String!) {
  viewer(device_token: $device_token) {
    email
  }
}
`

export const query = apollo.queries({
  hello, viewer
})

export const mutate = apollo.mutations({
  emailLogin
})

export const subscribe = apollo.subscriptions({
  viewer: viewerSubscription
})


