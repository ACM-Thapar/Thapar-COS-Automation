// *NPM Packages
const express = require('express');
const cors = require('cors');
const cookieSession = require('cookie-session');
const cookieParser = require('cookie-parser');
const passport = require('passport');

// *Config
const connectdb = require('./config/db');
const passportSetup = require('./config/passport-setup');
require('dotenv').config({ path: __dirname + '/.env' });

// *Routes
const authroutes = require('./routes/authroutes.js');
const userroutes = require('./routes/userroutes.js');

const app = express();

//initiaise passport
app.use(passport.initialize());
app.use(passport.session());

const PORT = process.env.PORT || 5000;

app.use(cors());

// *Connect to database
connectdb();

const server = app.listen(PORT, console.log(`Server started on Port ${PORT}`));

//add middlewares
app.use(express.json({ extended: false }));

// Cookie Parser
app.use(cookieParser());
app.use(
  cookieSession({
    maxAge: 24 * 60 * 60 * 1000,
    keys: [process.env.COOKIE_KEY],
  }),
);

// *Routes
app.use('/api/auth', authroutes);
app.use('/api/user', userroutes);

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
