// * Utils
const { check, validationResult } = require('express-validator');
const sendEmail = require('../utils/sendEmail');
const ErrorResponse = require('../utils/errorResponse');

// * NPM Packages
const bcrypt = require('bcryptjs');
const otpGenerator = require('otp-generator');
const nodemailer = require('nodemailer');
const { google } = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const compareAsc = require('date-fns/compareAsc');

// * Models
const { Shopkeeper } = require('../models/shopkeeper');
const { User } = require('../models/user');

// @desc     Register Shopkeeper
// @route    POST /api/auth/signup
// @access   Public
module.exports.post_signup = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email } = req.body;

  try {
    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (shopkeeper) {
      return ErrorResponse(res, 'User already exists', 400);
    }
    if (user) {
      return ErrorResponse(res, 'User with same email already exists', 400);
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
    shopkeeper = await Shopkeeper.create(newBody);
    const message = `Thanks for registering! We will need to verify your email first. You can do so by entering ${shopkeeper.otp.code}. This code is valid for only next 15 minutes.`;

    await sendEmail({
      email: shopkeeper.email,
      subject: 'Verification OTP',
      message,
    });

    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Register Firebase Shopkeeper
// @route    POST /api/auth/firebase-signup
// @access   Public
module.exports.firebaseRegisterShopkeeper = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { email } = req.body;

  try {
    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (shopkeeper) {
      return ErrorResponse(res, 'User already exists', 400);
    }
    if (user) {
      return ErrorResponse(res, 'User with same email already exists', 400);
    }

    const newBody = {
      ...req.body,
      isGoogleUser: true,
      isPhoneVerified: true,
      verified: true,
    };

    shopkeeper = await Shopkeeper.create(newBody);

    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'User does not exist', 400);
    }
    const isMatch = await bcrypt.compare(password, shopkeeper.password);
    if (!isMatch) {
      return ErrorResponse(res, 'Invalid credentials', 400);
    }
    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Verify Otp
// @route    POST /api/auth/verify-otp
// @access   Private
module.exports.verifyOtp = async (req, res) => {
  try {
    const shopkeeper = await Shopkeeper.findById(req.user.id);

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    const { otp } = req.body;

    if (shopkeeper.verified === true) {
      return ErrorResponse(res, 'Already verified', 400);
    }

    // Check if otp matches
    const isMatch = await shopkeeper.matchOtp(otp);

    if (!isMatch) {
      return ErrorResponse('Invalid otp', 401);
    }

    const currentTime = new Date(Date.now());

    if (compareAsc(new Date(shopkeeper.otp.validity), currentTime) === -1) {
      return ErrorResponse(res, 'Otp has expired', 400);
    }

    shopkeeper.verified = true;
    await shopkeeper.save({ validateBeforeSave: false });
    return res.status(200).json({ message: 'Sucessfully Verified' });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Regenerate Otp
// @route    PUT /api/auth/regenerate-otp
// @access   Private
module.exports.regenerateOtp = async (req, res) => {
  try {
    const shopkeeper = await Shopkeeper.findById(req.user.id);
    if (!shopkeeper) {
      return ErrorResponse(res, 'User does not exist', 400);
    }

    // if user is already verified
    if (shopkeeper.verified === true) {
      return ErrorResponse(res, 'User already verified', 400);
    }

    shopkeeper.otp.code = undefined;
    shopkeeper.otp.validity = undefined;
    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });

    console.log(otp);
    const validity = new Date(Date.now() + 15 * 60 * 1000);
    shopkeeper.otp.code = otp;
    shopkeeper.otp.validity = validity;
    await shopkeeper.save({ validateBeforeSave: false });
    const message = `Thanks for registering! We will need to verify your email first. You can do so by entering ${shopkeeper.otp.code}. This code is valid for only next 15 minutes.`;

    await sendEmail({
      email: shopkeeper.email,
      subject: 'Verification OTP',
      message,
    });

    sendTokenResponse(shopkeeper, 200, req, res);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Get current logged in shopkeeper
// @route    GET /api/auth/me
// @access   Private

module.exports.getMe = async (req, res) => {
  try {
    console.log(req.user);
    const user = await Shopkeeper.findById(req.user.id).populate('shops');
    if (!user) {
      return ErrorResponse(res, 'User not found', 400);
    }
    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Edit/Complete Profile
// @route    PUT /api/auth/complete-profile
// @access   Private

module.exports.completeProfile = async (req, res) => {
  try {
    if (req.body.email) {
      return ErrorResponse(res, 'Email cannot be updated', 400);
    }
    const updateData = { ...req.body };
    const user = await Shopkeeper.findByIdAndUpdate(req.user.id, updateData, {
      new: true,
      runValidators: true,
    }).exec();

    if (!user) {
      return ErrorResponse(res, 'User not found', 400);
    }
    const status = user.isCompleted;

    res.status(200).json({
      success: true,
      data: user,
      profileCompletion: status,
    });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
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
