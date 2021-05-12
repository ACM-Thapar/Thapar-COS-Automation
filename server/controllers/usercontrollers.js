// *Utils
const { check, validationResult } = require('express-validator');
const sendEmail = require('../utils/sendEmail');
const ErrorResponse = require('../utils/errorResponse');

// *NPM Packages
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const otpGenerator = require('otp-generator');
const nodemailer = require('nodemailer');
const compareAsc = require('date-fns/compareAsc');

// *Models
const { User } = require('../models/user');
const { Shopkeeper } = require('../models/shopkeeper');

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
      return ErrorResponse(res, 'Enter thapar mail id', 400);
    }

    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (user) {
      return ErrorResponse(res, 'User already exists', 400);
    }
    if (shopkeeper) {
      return ErrorResponse(
        res,
        'Shopkeeper with the same email id already exists',
        400,
      );
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
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'Enter thapar mail id', 400);
    }

    let [user, shopkeeper] = await Promise.all([
      User.findOne({ email: email }).lean().exec(),
      Shopkeeper.findOne({ email: email }).lean().exec(),
    ]);
    if (user) {
      return ErrorResponse(res, 'User already exists', 400);
    }
    if (shopkeeper) {
      return ErrorResponse(
        res,
        'Shopkeeper with the same email id already exists',
        400,
      );
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
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'User does not exist', 400);
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return ErrorResponse(res, 'Invalid credentials', 400);
    }
    sendTokenResponse(user, 200, req, res);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'Already verified', 400);
    }

    // Check if otp matches
    const isMatch = await user.matchOtp(otp);

    if (!isMatch) {
      return ErrorResponse(res, 'Invalid otp', 401);
    }

    const currentTime = new Date(Date.now());

    if (compareAsc(new Date(user.otp.validity), currentTime) === -1) {
      return ErrorResponse(res, 'Otp has expired', 400);
    }

    user.verified = true;
    await user.save({ validateBeforeSave: false });
    return res.status(200).json({ message: 'Sucessfully Verified' });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Regenerate Otp
// @route    PUT /api/user/regenerate-otp
// @access   Private
module.exports.regenerateOtp = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return ErrorResponse(res, 'User does not exist', 400);
    }

    // if user is already verified
    if (user.verified === true) {
      return ErrorResponse(res, 'User already verified', 400);
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
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'No user found', 400);
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
// @route    PUT /api/user/complete-profile
// @access   Private

module.exports.completeProfile = async (req, res) => {
  try {
    if (req.body.email) {
      return ErrorResponse(res, 'Email id cannot be updated', 400);
    }
    const updateData = { ...req.body };
    const user = await User.findByIdAndUpdate(req.user.id, updateData, {
      new: true,
      runValidators: true,
    }).exec();

    if (!user) {
      return ErrorResponse(res, 'No user found', 400);
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
//Favorite a shop and get the favourite shops
module.exports.favorite = async (req, res) => {
  try {
    let shop = await Shop.findById(req.params.id);
    let user = await User.findById(req.user.id);
    if (!shop) {
      return res.status(400).json({
        success: false,
        data: 'This shop does not exist',
      });
    }
    if (!user) {
      return res.status(400).json({
        success: false,
        data: 'user does not exist',
      });
    }
    const newBody = {
      shop: shop,
      user: user,
    };
    favorite = await Favoriteshop.create(newBody);
    // prints "The author is Ian Fleming"
    console.log(favorite + ' added');
    res.status(200).json({ success: true });
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};
//Show favorite shops
module.exports.showFavorites = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    const favoriteshops = await Favoriteshop.find({ user: user }).populate(
      'shop',
    );
    if (!favoriteshops) {
      return res.status(400).json({
        success: false,
        data: 'No favorite shops exist',
      });
    }
    res.status(200).json(favoriteshops);
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
