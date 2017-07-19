var path = require('path');
var webpack = require('webpack');
var publicPath = 'http://localhost:3000/';

module.exports = {
  devtool: 'source-map',
  entry: [
    path.join(__dirname, 'web/static/js/index.js'),
    'webpack-dev-server/client?http://localhost:3000',
    'webpack/hot/only-dev-server',
  ],
  output: {
    path: path.join(__dirname, '/priv/static/js'),
    filename: 'index.bundle.js',
    publicPath: publicPath,
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        loaders: ['babel-loader'],
        include: path.join(__dirname, 'web/static/js'),
        exclude: /node_modules/,
      },
    ],
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
  ],
  resolve: {
    // root: path.resolve(__dirname, 'web/static/js'),
    modules: [
      path.resolve(__dirname, 'node_modules'),
      path.resolve(__dirname, 'web/static/js'),
    ],
    extensions: ['.js', '.jsx'],
    alias: {
      // phoenix: path.join(__dirname, '/deps/phoenix/priv/static/phoenix.js'),
    },
  },
  devServer: {
    hot: true,
    port: 3000,
    historyApiFallback: true,
    watchOptions: { aggregateTimeout: 300, poll: 1000 },
    headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
        "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
    }
  },
};
