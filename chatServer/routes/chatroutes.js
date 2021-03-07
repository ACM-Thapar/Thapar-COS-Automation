// * NPM Packages
const express = require('express');

const router = express.Router();

// * Controllers
const chatcontrollers = require('../controllers/chatcontrollers');

// * Middlewares

router.get('/user/:id', chatcontrollers.getUser);
router.get('/shopkeeper/:id', chatcontrollers.getShopkeeper);

module.exports = router;
