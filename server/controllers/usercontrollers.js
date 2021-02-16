// *Utils
const { check, validationResult } = require('express-validator');
const sendEmail = require('../utils/sendEmail');

// *NPM Packages
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const otpGenerator = require('otp-generator');
const nodemailer = require('nodemailer');

// *Models
const User = require('../models/user');
const Shopkeeper = require('../models/shopkeeper');

// @desc     Register User
// @route    POST /api/user/signup
// @access   Public
module.exports.post_signup = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email } = req.body;

  try {
    // Domain check for thapar.edu
    if (!email.includes('@thapar.edu')) {
      return res.status(400).json('Enter a thapar edu email');
    }

    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (user) {
      return res.status(400).json('user already exists');
    }
    if (shopkeeper) {
      return res
        .status(400)
        .json('shopkeeper with the same email already exists');
    }

    //Generating an otp
    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });
    console.log(otp);
    const newBody = {
      ...req.body,
      otp: {
        code: otp,
      },
    };

    user = await User.create(newBody);
    const message = `Thanks for registering! We will need to verify your email first. You can do so by entering ${user.otp.code}. This code is valid for only next 15 minutes.`;

    await sendEmail({
      email: user.email,
      subject: 'Verification OTP',
      message,
    });

    sendTokenResponse(user, 200, req, res);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Register Firebase User
// @route    POST /api/user/firebase-signup
// @access   Public
module.exports.firebaseRegister = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email } = req.body;

  try {
    // Domain check for thapar.edu
    if (!email.includes('@thapar.edu')) {
      return res.status(400).json('Enter a thapar edu email');
    }

    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (user) {
      return res.status(400).json('user already exists');
    }
    if (shopkeeper) {
      return res
        .status(400)
        .json('shopkeeper with the same email already exists');
    }

    const newBody = {
      ...req.body,
      isGoogleUser: true,
      isPhoneVerified: true,
      verified: true,
    };

    user = await User.create(newBody);

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

// @desc     Verify Otp
// @route    POST /api/user/verify-otp
// @access   Private
module.exports.verifyOtp = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { otp } = req.body;

    if (user.verified === true) {
      return res.status(400).json({ errors: [{ msg: 'Already verified' }] });
    }

    // Check if otp matches
    const isMatch = await user.matchOtp(otp);

    if (!isMatch) {
      return res.status(401).json({ errors: [{ msg: 'Invalid otp' }] });
    }

    const currentTime = new Date(Date.now());
    if (user.otp.validity < currentTime) {
      return res.status(400).json({ errors: [{ msg: 'OTP has expired' }] });
    }

    user.verified = true;
    await user.save({ validateBeforeSave: false });
    return res.status(200).json({ message: 'Sucessfully Verified' });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Regenerate Otp
// @route    PUT /api/user/regenerate-otp
// @access   Private
module.exports.regenerateOtp = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(400).json({ errors: [{ msg: 'User does not exist' }] });
    }

    // if user is already verified
    if (user.verified === true) {
      return res
        .status(400)
        .json({ errors: [{ msg: 'User already verified' }] });
    }

    user.otp.code = undefined;
    user.otp.validity = undefined;
    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });

    console.log(otp);
    const validity = new Date(Date.now() + 15 * 60 * 1000);
    user.otp.code = otp;
    user.otp.validity = validity;
    await user.save({ validateBeforeSave: false });
    const message = `Thanks for registering! We will need to verify your email first. You can do so by entering ${user.otp.code}. This code is valid for only next 15 minutes.`;

    await sendEmail({
      email: user.email,
      subject: 'Verification OTP',
      message,
    });

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

// @desc     Edit/Complete Profile
// @route    PUT /api/user/complete-profile
// @access   Private

module.exports.completeProfile = async (req, res) => {
  try {
    if (req.body.email) {
      return res.status(400).json({
        success: false,
        data: 'Email cannot be updated',
      });
    }
    const updateData = { ...req.body };
    const user = await User.findByIdAndUpdate(req.user.id, updateData, {
      new: true,
      runValidators: true,
    }).exec();

    if (!user) {
      return res.status(400).json({
        success: false,
        data: 'No user found',
      });
    }
    const status = user.isCompleted;

    res.status(200).json({
      success: true,
      data: user,
      profileCompletion: status,
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
  const status = user.isCompleted;
  res
    .status(statusCode)
    .json({ success: true, token, profileCompletion: status });
};
