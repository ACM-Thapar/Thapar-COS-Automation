const express = require('express');
const router = express.Router();
const { check, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const shopController = require('../controllers/shopcontrollers');
const Shopkeeper = require('../models/shopkeeper');
const Shop = require('../models/shop');
const { userInfo } = require('os');
const passport = require('passport');
const { protectShopkeeper } = require('../middleware/auth');

//routes for SHOP
router.route('/createShop').post(protectShopkeeper, shopController.create_shop);
router.route('/updateShop').put(protectShopkeeper, shopController.update_shop);
router.route('/myShops').get(protectShopkeeper, shopController.myshops);
router.route('/deleteShop').get(protectShopkeeper, shopController.deleteshop);

module.exports = router;
