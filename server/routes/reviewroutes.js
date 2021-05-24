const express = require('express');

// * Controllers
const userController = require('../controllers/usercontrollers');
const {
  addreview,
  updatereview,
  deletereview,
  getreviewsByShopId,
  getreview,
  getreviewsforall,
} = require('../controllers/reviewcontrollers');

// * Middlewares
const { protectUser } = require('../middleware/auth');

// * API Endpoints -->
const router = express.Router();

router.post('/addreview/:id', [protectUser], addreview);
router.put('/updatereview/:id', [protectUser], updatereview);
router.delete('/deletereview/:id', [protectUser], deletereview);
router.get('/getreviews/:id', [protectUser], getreviewsByShopId);

//Unaunthenticated Routes
//To get a single review by id
router.get('/getreview/:id', getreview);
//To get all reviews for a paticular shop
router.get('/getreviewsforall/:id', getreviewsforall);

module.exports = router;
