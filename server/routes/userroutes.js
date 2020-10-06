const express = require('express');
const router = express.Router();
const { check, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/user');
const userController = require('../controllers/usercontrollers');
const { userInfo } = require('os');
const passport = require('passport');
const { protectUser } = require('../middleware/auth');

router.post('/signup', userController.post_signup);
router.post('/login', userController.post_login);
router.get('/me', [protectUser], userController.getMe);

// auth with google
router.get(
  '/google',
  passport.authenticate('google', {
    scope: ['profile', 'email'],
  }),
);

// callback for google auth
router.get('/google/redirect', passport.authenticate('google'), (req, res) => {
  res.redirect('http://localhost:3000/');
});

// auth logout
router.get('/logout', (req, res) => {
  // handle with passport
  req.logout();
  // res.redirect("http://localhost:3000/");
  res.json({ success: true, message: 'Logged out successfully' });
});

module.exports = router;
