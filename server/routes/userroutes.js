// * NPM Packages
const express = require('express');
const { check, validationResult } = require('express-validator');
const passport = require('passport');

const router = express.Router();

// * Controllers
const userController = require('../controllers/usercontrollers');

// * Middlewares
const { protectUser } = require('../middleware/auth');

router.post(
  '/signup',
  [check('email', 'Must be a valid email ').isEmail()],
  userController.post_signup,
);
router.post(
  '/firebase-signup',
  [check('email', 'Must be a valid email ').isEmail()],
  userController.firebaseRegister,
);
router.post(
  '/login',
  [check('email', 'Must be a valid email ').isEmail()],
  userController.post_login,
);
router.post('/verify-otp', [protectUser], userController.verifyOtp);
router.put('/regenerate-otp', [protectUser], userController.regenerateOtp);
router.get('/me', [protectUser], userController.getMe);
router.put('/complete-profile', [protectUser], userController.completeProfile);
router.post('/favorite/:id', [protectUser], userController.favorite);
router.get('/showFavorites', [protectUser], userController.showFavorites);
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
