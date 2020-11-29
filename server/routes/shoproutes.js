const express = require('express');

// * Controllers
const shopController = require('../controllers/shopcontrollers');

// * Middleware
const { protectShopkeeper } = require('../middleware/auth');

// * API Endpoints -->
const router = express.Router();

router.route('/createShop').post(protectShopkeeper, shopController.create_shop);
router
  .route('/updateShop/:id')
  .put(protectShopkeeper, shopController.update_shop);
router.route('/myShops').get(protectShopkeeper, shopController.myshops);
router
  .route('/deleteShop/:id')
  .delete(protectShopkeeper, shopController.deleteshop);
router.route('/getAllShops').get(shopController.get_all);
router.route('/get-shop/:id').get(shopController.getShopById);

module.exports = router;
