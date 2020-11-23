const express = require('express');

// * NPM packages
const multer = require('multer');

// * Models

// * Utils
const customStorage = require('../config/multer-storage');

// * Controllers
const { addInventory } = require('../controllers/inventorycontrollers');

// * Middleware
const { protectShopkeeper } = require('../middleware/auth');

// * Multer Config
const storage = customStorage({});

const upload = multer({
  storage: storage,
  fileFilter: function(req, file, cb) {
    checkFileType(file, cb);
  },
}).single('photo');

function checkFileType(file, cb) {
  // Make sure that the image is a photo
  if (!file.mimetype.startsWith('image')) {
    // return next(new ErrorResponse(`Please upload an image file`, 400));
    return cb('Error: Invalid file type.');
  }
  //Make sure the image is less than 4mb
  else if (file.size > 4000000) {
    return cb('Error: Invalid file size.');
  } else {
    return cb(null, true);
  }
}

// * API Endpoints -->
const router = express.Router();

router.post('/add-inventory/:id', [protectShopkeeper, upload], addInventory);

module.exports = router;
