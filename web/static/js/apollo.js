import R from 'ramda'
import xs from 'xstream'
import ApolloClient from 'apollo-client'
import {createNetworkInterface} from 'apollo-phoenix-websocket'

const uri = 'ws://localhost:4000/graphql'

const networkInterface = createNetworkInterface({
  uri,
  logger: true
})

const dataIdFromObject = R.path(['id'])

export const client = new ApolloClient({
  networkInterface, dataIdFromObject
})

const streamedP = R.mapObjIndexed((promiseF, name) => R.pipe(
  promiseF,
  xs.fromPromise,
  x => x.map(({data: {[name]: value}}) => value),
))

const operation = (method, doc) => gql => (variables, options = {}) =>
      client[method]({[doc]: gql, variables, ...options})

const queries = R.pipe(
  R.mapObjIndexed(operation('query', 'query')),
  streamedP)

const mutations = R.pipe(
  R.mapObjIndexed(operation('mutate', 'mutation')),
  streamedP)

const subscriptions = R.pipe(
  R.mapObjIndexed(operation('subscribe', 'query')),
  R.mapObjIndexed(fn => R.pipe(fn, xs.fromObservable)))

export default {queries, mutations, subscriptions}
