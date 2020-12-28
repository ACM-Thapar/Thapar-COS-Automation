const express = require('express');

// * Controllers
const {
  addOrder,
  viewOrder,
  viewAllOrders,
  updateOrder,
  deleteOrder,
} = require('../controllers/ordercontrollers');

// * Middleware
const { protectUser } = require('../middleware/auth');

// * API Endpoints -->
const router = express.Router();

router.post('/add-order/:id', [protectUser], addOrder);
router.get('/view-order/:id', [protectUser], viewOrder);
router.get('/view-all-orders', [protectUser], viewAllOrders);
router.put('/update-order/:id', [protectUser], updateOrder);
router.delete('/delete-order/:id', [protectUser], deleteOrder);

module.exports = router;
