// * Utils
const { check, validationResult } = require('express-validator');

// * NPM Packages

// * Models
const Shop = require('../models/shop');

// Route for shop profile creation by user
module.exports.create_shop = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, phone, timings, capacity, address } = req.body;
  try {
    let shops = await Shop.findOne({
      name,
      owner: req.user._id,
    }).lean();
    if (shops) {
      return res.status(400).json('Profile for this shop already exists');
    }

    shops = new Shop({
      owner: req.user._id,
      name,
      phone,
      timings,
      capacity,
      address,
    });
    console.log(shops);
    await shops.save();
    res.status(200).json({ success: true, shops });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// Route to update existing shop profile
module.exports.update_shop = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  const { name, phone, status, timings, capacity, address } = req.body;
  const fields = req.body;
  try {
    let update_shop = await Shop.findById(req.params.id).lean();
    //If shop does not exist in database
    if (!update_shop) {
      return res.status(400).json('Shop Profile does not exist');
    }
    //To check if current logged in user is the owner of the shop
    if (update_shop.owner.toString() != req.user._id.toString()) {
      return res.status(400).json('Only owner can update shop profile');
    }

    let shop = await Shop.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runVaildators: true,
    });

    res.status(200).send(shop);
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
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
      return res.status(400).json({
        success: false,
        data: 'No shop exist',
      });
    }
    return res.status(200).json(myshops);
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
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
      return res.status(400).json({
        success: false,
        data: 'No shop exist',
      });
    }
    if (check_shop.owner.toString() != req.user._id.toString()) {
      return res.status(401).json('Only owner can delete shop profile');
    }
    await check_shop.remove();
    return res
      .status(200)
      .json({ success: true, message: 'Deleted Sucessfully' });
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};

//Getting all shops for DashBoard display
module.exports.get_all = async (req, res) => {
  try {
    const allShops = await Shop.find({}).lean();
    if (!allShops) {
      return res.status(400).json({
        success: false,
        data: 'No shop exist',
      });
    }
    return res.status(200).json({ sucess: true, data: allShops });
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};

// @desc     Get a shop by Id
// @route    GET /api/shop/get-shop/:id
// @access   Public
module.exports.getShopById = async (req, res) => {
  try {
    const shop = await Shop.findById(req.params.id).populate('inventory');
    if (!shop) {
      return res.status(400).json({
        success: false,
        data: "Shop doesn't exist",
      });
    }
    res.status(200).json({ success: true, data: shop });
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};