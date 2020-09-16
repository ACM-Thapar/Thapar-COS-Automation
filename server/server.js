const express = require('express');
const cors = require('cors');
const connectdb = require('./config/db');
const app = express();
const authroutes = require('./routes/authroutes.js');

const PORT = process.env.PORT || 5000;
app.use(cors());
connectdb();
const server = app.listen(PORT, console.log(`Server started on Port ${PORT}`));

//add middlewares
app.use(express.json({ extended: false }));
//add routes
app.use('/api/auth', authroutes);
// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
