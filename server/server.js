const express = require('express');
const connectdb = require('./config/db');
const app = express();

const PORT = process.env.PORT || 5000;
connectdb();
const server = app.listen(PORT, console.log(`Server started on Port ${PORT}`));

//add middlewares

//add routes

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
