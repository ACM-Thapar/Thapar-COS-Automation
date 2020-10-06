// *NPM Packages
const jwt = require('jsonwebtoken');

// *Models
const User = require('../models/user');
const Shopkeeper = require('../models/shopkeeper');

// Protect routes for user
exports.protectUser = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.user) {
    // next();
  } else if (req.session.token) {
    token = req.session.token;
  }

  // Make sure token exists
  if (!token && req.user === null) {
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route',
    });
  }

  try {
    if (req.user) {
      next();
    } else {
      // Verify token
      const decoded = jwt.verify(token, process.env.JWTTOKEN);

      console.log(decoded);

      req.user = await User.findById(decoded.id);

      next();
    }
  } catch (err) {
    console.log('Error', err);
    return res
      .status(401)
      .json({ success: false, message: 'Not authorized to access this route' });
  }
};

// Protect routes for shopkeeper
exports.protectShopkeeper = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.user) {
    // next();
  } else if (req.session.token) {
    token = req.session.token;
  }

  // Make sure token exists
  if (!token && req.user === null) {
    return res.status(401).json({
      success: false,
      message: 'Not authorized to access this route',
    });
  }

  try {
    if (req.user) {
      next();
    } else {
      // Verify token
      const decoded = jwt.verify(token, process.env.JWTTOKEN);

      console.log(decoded);

      req.user = await Shopkeeper.findById(decoded.id);

      next();
    }
  } catch (err) {
    console.log('Error', err);
    return res
      .status(401)
      .json({ success: false, message: 'Not authorized to access this route' });
  }
};
