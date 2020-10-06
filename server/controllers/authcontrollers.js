// * Utils
const { check, validationResult } = require('express-validator');

// * NPM Packages
const bcrypt = require('bcryptjs');

// * Models
const Shopkeeper = require('../models/shopkeeper');

// @desc     Register Shopkeeper
// @route    POST /api/auth/signup
// @access   Public
module.exports.post_signup = async (req, res) => {
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

    await shopkeeper.save();

    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Login Shopkeeper
// @route    POST /api/auth/register
// @access   Public
module.exports.post_login = async (req, res) => {
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
      return res.status(400).json({ errors: [{ msg: 'invalid credentials' }] });
    }
    const isMatch = await bcrypt.compare(password, shopkeeper.password);
    if (!isMatch) {
      return res.status(400).json({ errors: [{ msg: 'invalid credentials' }] });
    }
    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Get current logged in shopkeeper
// @route    GET /api/auth/me
// @access   Private

module.exports.getMe = async (req, res) => {
  try {
    console.log(req.user);
    const user = await Shopkeeper.findById(req.user.id);
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
