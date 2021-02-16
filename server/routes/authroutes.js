// * NPM Packages
const express = require('express');
const passport = require('passport');

const router = express.Router();

// * Controllers
const authController = require('../controllers/authcontrollers');

// * Middlewares
const { protectShopkeeper } = require('../middleware/auth');

router.post('/signup', authController.post_signup);
router.post('/firebase-signup', authController.firebaseRegisterShopkeeper);
router.post('/login', authController.post_login);
router.post('/verify-otp', [protectShopkeeper], authController.verifyOtp);
router.put(
  '/regenerate-otp',
  [protectShopkeeper],
  authController.regenerateOtp,
);
router.get('/me', [protectShopkeeper], authController.getMe);
router.put(
  '/complete-profile',
  [protectShopkeeper],
  authController.completeProfile,
);

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
