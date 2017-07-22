import R from 'ramda'
import xs from 'xstream'
import React from 'react'


import {
  mapPropsStreamWithConfig
} from 'recompose'

import xstreamConfig from 'recompose/xstreamObservableConfig'
const mapPropsStream = mapPropsStreamWithConfig(xstreamConfig)

export const debug = (...args) => value => (console.log(...args, value), value)
export const listen = listener => v$ => (v$.addListener(listener), v$)
export const debugListener = R.pipe(debug, next => ({next}), listen)

const $objIndexed = R.pipe(
  R.mapObjIndexed((s, name) => s.map(value => ({[name]: value}))),
  R.values,
  all => xs.combine(...all),
  all$ => all$.map(R.mergeAll))

export const $mergeObj = R.curry((o, o$) => mergeObj$(o$, $objIndexed(o)))
export const mergeObj$ = R.curry((a$, b$) => xs.combine(a$, b$).map(R.mergeAll))

export const eventValue = R.path(['target', 'value'])
export const forwardTo = s$ => value => (s$.shamefullySendNext(value), value)

export const withProps$ = object =>
  typeof object === 'function' ?
  withStore((Props, props$) => $mergeObj(object(Props), props$))
  : mapPropsStream($mergeObj(object))


const wrapStore = store => mapPropsStream(
  props$ => props$.take(1)
    .map(props => {
      try {
        return store(props, props$.startWith(props))
      } catch (e) {
        console.error("ERROR CREATING STORE ", e)
        throw e
      }
    }).flatten())

export const withStore = store => cmp => {
  const X = wrapStore(store)(cmp)
  return props => <X {...props} />
}
