const express = require('express');
const { check } = require('express-validator');

// * NPM packages
const multer = require('multer');

// * Models

// * Utils
const customStorage = require('../config/multer-storage');

// * Controllers
const {
  addInventory,
  markInventoryAvailablity,
  updateInventoryProduct,
  deleteInventoryProduct,
} = require('../controllers/inventorycontrollers');

// * Middleware
const { protectShopkeeper } = require('../middleware/auth');

// * Multer Config
const storage = customStorage({});

const upload = multer({
  storage: storage,
  fileFilter: function (req, file, cb) {
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

router.post(
  '/add-inventory/:id',
  [check('category', 'Please add an item category'), protectShopkeeper, upload],
  addInventory,
);
router.put(
  '/update-availability/:id',
  [protectShopkeeper],
  markInventoryAvailablity,
);
router.put(
  '/update-product/:id',
  [protectShopkeeper, upload],
  updateInventoryProduct,
);
router.delete(
  '/delete-product/:id',
  [protectShopkeeper],
  deleteInventoryProduct,
);
module.exports = router;
