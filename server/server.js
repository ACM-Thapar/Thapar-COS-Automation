// *NPM Packages
const express = require('express');
const cors = require('cors');
const session = require('express-session');
const redis = require('redis');
const connectRedis = require('connect-redis');
const passport = require('passport');

// *Config
const connectdb = require('./config/db');
const passportSetup = require('./config/passport-setup');
require('dotenv').config({ path: __dirname + '/.env' });

// *Routes
const authroutes = require('./routes/authroutes.js');
const userroutes = require('./routes/userroutes.js');
const shoproutes = require('./routes/shoproutes.js');
const inventoryroutes = require('./routes/inventoryroutes');
const orderroutes = require('./routes/orderroutes.js');

const app = express();

const PORT = process.env.PORT || 5000;

app.use(
  cors({
    origin: 'http://localhost:3000',
    credentials: true,
  }),
);

// *Connect to database
connectdb();

const server = app.listen(PORT, console.log(`Server started on Port ${PORT}`));

//add middlewares
app.use(express.json({ extended: false }));

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:3000');
  res.header('Access-Control-Allow-Credentials', true);
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept',
  );
  next();
});

// * Redis Configuration
// const RedisStore = connectRedis(session);

// * Configure redis client
// const redisClient = redis.createClient({
//   host: process.env.REDIS_HOST,
//   port: process.env.REDIS_PORT,
// });

// redisClient.on('error', function (err) {
//   console.log('Could not establish a connection with redis. ' + err);
// });
// redisClient.on('connect', function (err) {
//   console.log('Connected to redis successfully');
// });

// * Configure session middleware
// app.use(
//   session({
//     store: new RedisStore({ client: redisClient }),
//     secret: process.env.COOKIE_KEY,
//     resave: false,
//     saveUninitialized: false,
//     cookie: {
//       secure: false, // if true only transmit cookie over https
//       httpOnly: true, // if true prevent client side JS from reading the cookie
//       maxAge: 24 * 60 * 60 * 1000, // session max age in miliseconds
//     },
//   }),
// );

//initiaise passport
app.use(passport.initialize());
app.use(passport.session());

// *Routes
app.use('/api/auth', authroutes);
app.use('/api/user', userroutes);
app.use('/api/shop', shoproutes);
app.use('/api/inventory', inventoryroutes);
app.use('/api/order', orderroutes);

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
