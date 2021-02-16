const express = require('express');

// * NPM packages
const multer = require('multer');

// * Utils
const customStorage = require('../config/multer-storage');

// * Controllers
const shopController = require('../controllers/shopcontrollers');

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

router
  .route('/createShop')
  .post([protectShopkeeper, upload], shopController.create_shop);
router
  .route('/updateShop/:id')
  .put([protectShopkeeper, upload], shopController.update_shop);
router.route('/myShops').get(protectShopkeeper, shopController.myshops);
router
  .route('/deleteShop/:id')
  .delete(protectShopkeeper, shopController.deleteshop);
router.route('/getAllShops').get(shopController.get_all);
router.route('/get-shop/:id').get(shopController.getShopById);

module.exports = router;
