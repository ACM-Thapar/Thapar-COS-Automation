const express = require('express');
const router = express.Router();
const { check, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const dotenv = require('dotenv');
const authController = require('../controllers/authcontrollers');
const Shopkeeper = require('../models/shopkeeper');
const { userInfo } = require('os');

dotenv.config();
/*router.post(
  '/signup',
  [
    //check('name', 'Name is required').not().isEmpty(),
    //check('email', 'please include a valid email').isEmail(),
    //check('password', 'please include a valid password').isLength({ min: 4 })
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, phone, email, password, shop } = req.body;

    try {
      let shopkeeper = await Shopkeeper.findOne({ email: email });
      if (shopkeeper) {
        return res.status(400).json('user already exists');
      }

      shopkeeper = new Shopkeeper({
        name: name,
        phone: phone,
        email: email,
        password: password,
        shop: shop,
      });

      const salt = await bcrypt.genSalt(10);
      shopkeeper.password = await bcrypt.hash(password, salt);
      await shopkeeper.save();
      //saving the shopkeeper after hashing and salting the password
      //Return jsonwebToken
      const payload = {
        user: {
          _id: shopkeeper._id,
        },
      };
      jwt.sign(payload, process.env.JWTTOKEN, (err, token) => {
        if (err) throw err;
        else {
          res.json({ token });
        }
      }); //generally kept 3600 ie 1hr but as now testing it is kept more change it before deployment
    } catch (err) {
      console.log(err);
      res.status(500).send('server error');
    }
  },
);

//*******************Checking for the login************************************
router.post(
  '/login',
  [
    //check('email', 'please include a valid email').isEmail(),
    //check('password', 'please include a valid password').exists
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { email, password } = req.body;
    //to check if the user already exists
    try {
      console.log('reached');
      let shopkeeper = await Shopkeeper.findOne({ email: email });
      console.log(shopkeeper);
      if (!shopkeeper) {
        return res
          .status(400)
          .json({ errors: [{ msg: 'invalid credentials' }] });
      }
      const isMatch = await bcrypt.compare(password, shopkeeper.password);
      if (!isMatch) {
        return res
          .status(400)
          .json({ errors: [{ msg: 'invalid credentials' }] });
      }
      //Return jsonwebToken
      const payload = {
        shopkeeper: {
          _id: shopkeeper._id,
        },
      };
      jwt.sign(payload, process.env.JWTTOKEN, (err, token) => {
        if (err) throw err;
        else {
          res.json({ token });
        }
      }); //generally kept 3600 ie 1hr but as now testing it is kept more change it before deployment
    } catch (err) {
      console.log(err);
      res.status(500).send('server error');
    }
  },
);*/
router.post('/signup', authController.post_signup);
router.post('/login', authController.post_login);
module.exports = router;
