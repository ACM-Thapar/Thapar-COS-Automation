// * Utils
const { check, validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

// * NPM Packages

// * Models
const Shop = require('../models/shop');
const FavoriteShop = require('../models/favoriteshop');

// Route for shop profile creation by user
module.exports.create_shop = async (req, res) => {
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
      return ErrorResponse(res, 'Profile for this shop already exists', 400);
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
    return ErrorResponse(res, 'Server error', 500);
  }
};

// Route to update existing shop profile
module.exports.update_shop = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    let update_shop = await Shop.findById(req.params.id).lean();
    //If shop does not exist in database
    if (!update_shop) {
      return ErrorResponse(res, 'Shop profile does not exist', 400);
    }
    //To check if current logged in user is the owner of the shop
    if (update_shop.owner.toString() != req.user._id.toString()) {
      return ErrorResponse(res, 'Only owner can update the shop profile', 400);
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
    return ErrorResponse(res, 'Server error', 500);
  }
};

//Route to display all shop profiles of a paticular shopkeeper
module.exports.myshops = async (req, res) => {
  try {
    console.log(req.user._id);
    const myshops = await Shop.find({ owner: req.user._id }).populate(
      'inventory',
    );
    if (!myshops) {
      return ErrorResponse(res, 'No shop exist', 400);
    }
    return res.status(200).json(myshops);
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Delete a shop by Id
// @route    DELETE /api/shop/deleteShop/:id
// @access   Private
module.exports.deleteshop = async (req, res) => {
  try {
    console.log(req.user._id);
    let check_shop = await Shop.findById(req.params.id);
    if (!check_shop) {
      return ErrorResponse(res, 'No shop exist', 400);
    }
    if (check_shop.owner.toString() != req.user._id.toString()) {
      return ErrorResponse(res, 'Only owner can delete shop profile', 401);
    }
    await check_shop.remove();
    return res
      .status(200)
      .json({ success: true, message: 'Deleted Sucessfully' });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Get all shops(unauthenticated) || Get all shops catered to a particular user
// @route    GET /api/shop/getAllShops || GET /api/shop/getAllShopsTimeline
// @access   Public || Private
module.exports.get_all = async (req, res) => {
  try {
    const allShops = await Shop.find({}).lean();
    if (!allShops) {
      return ErrorResponse(res, 'No shop exist', 400);
    }
    if (req.user) {
      const newData = [];
      await Promise.all(
        allShops.map(async (item) => {
          const isLiked = await FavoriteShop.findOne({
            shopDetails: item._id,
            user: req.user.id,
          })
            .lean()
            .exec();
          item.isFavourited = false;
          if (isLiked) {
            item.isFavourited = true;
          }
          newData.push(item);
        }),
      );
      return res.status(200).json({ sucess: true, data: newData });
    }
    return res.status(200).json({ sucess: true, data: allShops });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Get a shop by Id || Get a shop by Id catered to a user
// @route    GET /api/shop/get-shop/:id || GET /api/shop/get-shop-user/:id
// @access   Public || Private
module.exports.getShopById = async (req, res) => {
  try {
    const shop = await Shop.findById(req.params.id).populate('inventory');
    if (!shop) {
      return ErrorResponse(res, 'Shop does not exist', 400);
    }
    if (req.user) {
      let isFavourited = false;
      const isLiked = await FavoriteShop.findOne({
        shopDetails: shop._id,
        user: req.user.id,
      })
        .lean()
        .exec();
      if (isLiked) {
        isFavourited = true;
      }
      return res.status(200).json({ success: true, data: shop, isFavourited });
    }
    res.status(200).json({ success: true, data: shop });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};
