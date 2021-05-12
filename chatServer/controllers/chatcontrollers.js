//  * Utils
const ErrorResponse = require('../../server/utils/errorResponse');

// * Models
const User = require('../models/User');
const Shopkeeper = require('../models/Shopkeeper');

// @desc     Fetch a User from the main db
// @route    GET /api/chat/user/:id
// @access   Public
module.exports.getUser = async (req, res, next) => {
  // const errors = validationResult(req);
  // if (!errors.isEmpty()) {
  //   return res.status(400).json({ errors: errors.array() });
  // }

  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Fetch a Shopkeeper from the main db
// @route    GET /api/chat/shopkeeper/:id
// @access   Public
module.exports.getShopkeeper = async (req, res, next) => {
  // const errors = validationResult(req);
  // if (!errors.isEmpty()) {
  //   return res.status(400).json({ errors: errors.array() });
  // }

  try {
    const shopkeeper = await Shopkeeper.findById(req.params.id);

    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    res.status(200).json({
      success: true,
      data: shopkeeper,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};
