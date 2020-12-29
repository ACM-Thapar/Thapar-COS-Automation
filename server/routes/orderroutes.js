const express = require('express');

// * Controllers
const {
  addOrder,
  viewOrder,
  viewAllOrders,
  updateOrderUser,
  updateOrderShopkeeper,
  deleteOrderUser,
  deleteOrderShopkeeper,
} = require('../controllers/ordercontrollers');

// * Middleware
const { protectUser, protectShopkeeper } = require('../middleware/auth');

// * API Endpoints -->
const router = express.Router();

router.post('/add-order/:id', [protectUser], addOrder);
router.get('/view-order/:id', [protectUser], viewOrder);
router.get('/view-all-orders', [protectUser], viewAllOrders);
router.put('/update-order-user/:id', [protectUser], updateOrderUser);
router.put(
  '/update-order-shopkeeper/:id',
  [protectShopkeeper],
  updateOrderShopkeeper,
);
router.delete('/delete-order-user/:id', [protectUser], deleteOrderUser);
router.delete(
  '/delete-order-shopkeeper/:id',
  [protectShopkeeper],
  deleteOrderShopkeeper,
);

module.exports = router;
