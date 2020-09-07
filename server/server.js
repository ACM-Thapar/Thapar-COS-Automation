const express = require("express");

const app = express();

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, console.log(`Server started on Port ${PORT}`));

// Handle unhandled promise rejections
process.on("unhandledRejection", (err, promise) => {
  console.log(`Error: ${err.message}`);
  // Close server and exit process
  server.close(() => process.exit(1));
});
