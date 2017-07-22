import 'react-hot-loader/patch'
import React from 'react'
import ReactDOM from 'react-dom'
import { AppContainer } from 'react-hot-loader'



const render = _ => {
  const App = require('./app').default
  ReactDOM.render(<AppContainer><App /></AppContainer>, document.getElementById('app'))
}

render()

const style = '<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.11/semantic.min.css"></link>'
document.write(style)

if (module.hot) {
  module.hot.accept('./app', render)
}
