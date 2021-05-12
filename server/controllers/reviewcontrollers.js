// * Utils
const { check, validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

// * Models
const User = require('../models/user');
const Shop = require('../models/shop');
const Review = require('../models/reviews');

// @desc     Add a  review
// @route    POST /api/review/addreview/:id
// @access   Private

module.exports.addreview = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const shop = await Shop.findById(req.params.id);
    if (!shop) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'Shop does not exist', 400);
    }
    const review = new Review({
      title: req.body.title,
      text: req.body.text,
      rating: req.body.rating,
      shop: req.params.id,
      user: req.user.id,
    });

    await review.save();
    return res
      .json({
        success: true,
        data: review,
      })
      .status(200);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc   Update a  review
// @route    PUT /api/review/updatereview/:id
// @access   Private

module.exports.updatereview = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    let review = await Review.findById(req.params.id).lean();
    if (!review) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'review does not exist', 400);
    }
    review = await Review.findByIdAndUpdate(req.params.id, req.body, {
      runValidators: false,
      new: true,
    });
    res.status(200).json({ success: true, data: review });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc   delete a  review
// @route    PUT /api/review/deletereview/:id
// @access   Private

module.exports.deletereview = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    let review = await Review.findById(req.params.id).lean();
    if (!review) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'review does not exist', 400);
    }
    await Review.findByIdAndRemove(req.params.id);

    res.status(200).json({ success: true });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc  get all reviews for a shop
// @route    PUT /api/review/getreviews/:id
// @access   Private

module.exports.getreviews = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const shop = await Shop.findById(req.params.id);
    if (!shop) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'Shop does not exist', 400);
    }
    let reviews = await Review.find({ shop: req.params.id });
    if (!reviews) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'review does not exist', 400);
    }

    res.status(200).json({ success: true, data: reviews });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc  get a single review by review id
// @route    GET /api/review/getreview/:id
// @access   Private

module.exports.getreview = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const review = await Review.findById(req.params.id);
    if (!review) {
      // * Throw error if shop doesn't exists
      return ErrorResponse(res, 'review does not exist', 400);
    }

    res.status(200).json({ success: true, data: review });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};
