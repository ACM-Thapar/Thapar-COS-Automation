// *NPM Packages
const express = require('express');
const cors = require('cors');
const cookieSession = require('cookie-session');
const cookieParser = require('cookie-parser');

// *Config
const { mainDBConnection, chatDBConnection } = require('./config/db');
require('dotenv').config({ path: __dirname + '/.env' });

// *Routes
const chatroutes = require('./routes/chatroutes.js');

const app = express();

const PORT = process.env.PORT || 8000;

app.use(
  cors({
    origin: 'http://localhost:3000',
    credentials: true,
  }),
);

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

// Cookie Parser
app.use(cookieParser());
app.use(
  cookieSession({
    maxAge: 24 * 60 * 60 * 1000,
    keys: [process.env.COOKIE_KEY],
  }),
);

// *Routes
app.use('/chat-api/chat', chatroutes);

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
