// * Utils
const { check, validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

// * NPM Packages

// * Models
const Shop = require('../models/shop');

// Route for shop profile creation by user
module.exports.create_shop = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, phone, timings, capacity, address, category } = req.body;
  try {
    let shops = await Shop.findOne({
      name,
      owner: req.user._id,
    }).lean();
    if (shops) {
      return next(
        new ErrorResponse('Profile for this shop already exists', 400),
      );
    }
    if (req.file) {
      // check if image is uploaded
      shops = new Shop({
        owner: req.user._id,
        name,
        phone,
        timings,
        capacity,
        address,
        category,
        photo: req.file.url,
      });
    } else if (!req.file) {
      shops = new Shop({
        owner: req.user._id,
        name,
        phone,
        timings,
        capacity,
        address,
        category,
      });
    }
    console.log(shops);
    await shops.save();
    res.status(200).json({ success: true, shops });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// Route to update existing shop profile
module.exports.update_shop = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    let update_shop = await Shop.findById(req.params.id).lean();
    //If shop does not exist in database
    if (!update_shop) {
      return next(new ErrorResponse('Shop profile does not exist', 400));
    }
    //To check if current logged in user is the owner of the shop
    if (update_shop.owner.toString() != req.user._id.toString()) {
      return next(
        new ErrorResponse('Only owner can update the shop profile', 400),
      );
    }

    if (req.file) {
      req.body.photo = req.file.url;
    }
    let shop = await Shop.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runVaildators: true,
    });

    res.status(200).send(shop);
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

//Route to display all shop profiles of a paticular shopkeeper
module.exports.myshops = async (req, res, next) => {
  try {
    console.log(req.user._id);
    const myshops = await Shop.find({ owner: req.user._id }).populate(
      'inventory',
    );
    if (!myshops) {
      return next(new ErrorResponse('No shop exist', 400));
    }
    return res.status(200).json(myshops);
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Delete a shop by Id
// @route    DELETE /api/shop/deleteShop/:id
// @access   Private
module.exports.deleteshop = async (req, res, next) => {
  try {
    console.log(req.user._id);
    let check_shop = await Shop.findById(req.params.id);
    if (!check_shop) {
      return next(new ErrorResponse('No shop exist', 400));
    }
    if (check_shop.owner.toString() != req.user._id.toString()) {
      return next(new ErrorResponse('Only owner can delete shop profile', 401));
    }
    await check_shop.remove();
    return res
      .status(200)
      .json({ success: true, message: 'Deleted Sucessfully' });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

//Getting all shops for DashBoard display
module.exports.get_all = async (req, res, next) => {
  try {
    const allShops = await Shop.find({}).lean();
    if (!allShops) {
      return next(new ErrorResponse('No shop exist', 400));
    }
    return res.status(200).json({ sucess: true, data: allShops });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Get a shop by Id
// @route    GET /api/shop/get-shop/:id
// @access   Public
module.exports.getShopById = async (req, res, next) => {
  try {
    const shop = await Shop.findById(req.params.id).populate('inventory');
    if (!shop) {
      return next(new ErrorResponse('Shop does not exist', 400));
    }
    res.status(200).json({ success: true, data: shop });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};
