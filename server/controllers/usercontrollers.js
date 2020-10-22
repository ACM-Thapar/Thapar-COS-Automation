// *Utils
const { check, validationResult } = require('express-validator');

// *NPM Packages
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// *Models
const User = require('../models/user');

// @desc     Register User
// @route    POST /api/user/signup
// @access   Public
module.exports.post_signup = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, phone, email, password, hostel } = req.body;

  try {
    // Domain check for thapar.edu
    if (!email.includes('@thapar.edu')) {
      return res.status(400).json('Enter a thapar edu email');
    }
    let user = await User.findOne({ email: email });
    if (user) {
      return res.status(400).json('user already exists');
    }

    user = new User({
      name: name,
      phone: phone,
      email: email,
      password: password,
      hostel: hostel,
    });

    await user.save();
    sendTokenResponse(user, 200, req, res);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Login User
// @route    POST /api/user/login
// @access   Public
module.exports.post_login = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  const { email, password } = req.body;
  //to check if the user already exists
  try {
    let user = await User.findOne({ email: email });

    if (!user) {
      return res.status(400).json({ errors: [{ msg: 'invalid credentials' }] });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ errors: [{ msg: 'invalid credentials' }] });
    }
    sendTokenResponse(user, 200, req, res);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Get current logged in user
// @route    GET /api/user/me
// @access   Private

module.exports.getMe = async (req, res) => {
  try {
    console.log(req.user);
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(400).json({
        success: false,
        data: 'No user found',
      });
    }
    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};

// Get token from model, create cookie and send response
const sendTokenResponse = (user, statusCode, req, res) => {
  // Create token
  const token = user.getSignedJwtToken();
  req.session.token = token;
  res.status(statusCode).json({ success: true, token });
};
