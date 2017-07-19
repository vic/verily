import 'react-hot-loader/patch'
import React from 'react'
import ReactDOM from 'react-dom'
import { AppContainer } from 'react-hot-loader'

const render = _ => {
  const App = require('./app').default
  ReactDOM.render(<AppContainer><App /></AppContainer>, document.getElementById('app'))
}

render()
console.log(module.hot)

if (module.hot) {
  module.hot.accept('./app', render)
}
