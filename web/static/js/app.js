import R from 'ramda'
import React from 'react'
import xs from 'xstream'
import sampleCombine from 'xstream/extra/sampleCombine'

import {
  BrowserRouter as Router,
  Route,
  Link
} from 'react-router-dom'

import {
  withRouter,
} from 'react-router'

import {query, mutate, subscribe} from './api'

import {
  listen,
  debug,
  debugListener,
  withStore,
  $mergeObj,
  eventValue,
  forwardTo,
  withProps$,
} from './fun'

import {
  compose
} from 'recompose'

import {
  Form,
  Dimmer,
  Loader,
  Image,
  Segment
} from 'semantic-ui-react'


const DEVICE_TOKEN =
      (Date.now().toString(36) + Math.random().toString(36).substr(2, 8)).toUpperCase()

const verifying$ = xs.create()

// Send a hello query to the backend
query.hello({}).addListener(console.log.bind(console, 'HELLO'))

const emailLoginView = ({emailChange, submit, loading}) => (
  <Form onSubmit={submit}>
    <Form.Input label='Email' type='email' onChange={emailChange} />
    <Form.Button>Login</Form.Button>
  </Form>
)

const emailLoginStore = (Props, props$) => {
  const email$ = xs.create()
  const submit$ = xs.create()

  submit$.compose(sampleCombine(email$))
    .map(([_, email]) => ({email, device_token: DEVICE_TOKEN}))
    .map(mutate.emailLogin)
    .flatten()
    .map(forwardTo(verifying$))
    .compose(listen(R.identity))

  const emailChange = R.pipe(eventValue, forwardTo(email$))
  const submit = forwardTo(submit$)

  return $mergeObj({
    emailChange: xs.of(emailChange),
    submit: xs.of(submit),
  }, props$)
}

const EmailLogin = compose(
  withStore(emailLoginStore)
)(emailLoginView)

const emailFromLoc = R.path(['location', 'state', 'viewer', 'email'])
const Welcome = props => (
  <h1>Your verified email is: {emailFromLoc(props)}</h1>
)

const appView = props => (
  <Segment>
    <Dimmer active={props.verifying}>
      <Loader>
        Waiting for email confirmation.
        Please check your <a href='/inbox' target='_blank'>Inbox</a>
      </Loader>
    </Dimmer>

    <div>
      <h2>Verily</h2>
      <ul>
        <li><Link to="/login/email">Login with Email</Link></li>
        <li><Link to="/inbox" target="_blank">Inbox</Link></li>
      </ul>
      <Route path="/login/email" exact render={EmailLogin} />
      <Route path="/welcome" exact render={Welcome} />
    </div>
  </Segment>
)

const App = compose(
  withRouter,
  withStore((Props, props$) => {

    // subscribe to current viewer
    const viewer$ = subscribe.viewer({device_token: DEVICE_TOKEN})

    // Redirect when viewer's email is confirmed
    viewer$.compose(sampleCombine(props$))
      .map(([viewer, {history}]) =>
           history.replace({pathname: '/welcome', state: viewer}))
      .addListener({next: _ => forwardTo(verifying$)(false) })

    return $mergeObj({
      verifying: verifying$.map(x => !!x).startWith(false)
    }, props$)
  })
)(appView)

export default props => (<Router><App /></Router>)
