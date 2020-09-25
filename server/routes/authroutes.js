const express = require('express');
const router = express.Router();
const { check, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const authController = require('../controllers/authcontrollers');
const Shopkeeper = require('../models/shopkeeper');
const { userInfo } = require('os');
const passport = require('passport');

router.post('/signup', authController.post_signup);
router.post('/login', authController.post_login);

// auth with google
router.get(
  '/google',
  passport.authenticate('google-shopkeeper', {
    scope: ['profile', 'email'],
  }),
);

// callback for google auth
router.get(
  '/google/redirect',
  passport.authenticate('google-shopkeeper'),
  (req, res) => {
    res.redirect('http://localhost:3000/');
  },
);

// auth logout
router.get('/logout', (req, res) => {
  // handle with passport
  req.logout();
  // res.redirect("http://localhost:3000/");
  res.json({ success: true, message: 'Logged out successfully' });
});

module.exports = router;
