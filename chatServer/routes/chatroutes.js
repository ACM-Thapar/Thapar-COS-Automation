// * NPM Packages
const express = require('express');

const router = express.Router();

// * Controllers
const chatcontrollers = require('../controllers/chatcontrollers');

// * Middlewares

router.get('/user/:id', chatcontrollers.getUser);
router.get('/shopkeeper/:id', chatcontrollers.getShopkeeper);
router.post('/add-conversation/user/:id', chatcontrollers.addConversationUser);
router.post(
  '/add-conversation/shopkeeper/:id',
  chatcontrollers.addConversationShopkeeper,
);
router.get('/my-conversation/user/:id', chatcontrollers.getConversationUser);
router.get(
  '/my-conversation/shopkeeper/:id',
  chatcontrollers.getConversationShopkeeper,
);
router.get('/conversation/user/:id', chatcontrollers.getConversationByIdUser);
router.get(
  '/conversation/shopkeeper/:id',
  chatcontrollers.getConversationByIdShopkeeper,
);

module.exports = router;
