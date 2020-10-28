// * Utils
const { check, validationResult } = require('express-validator');

// * NPM Packages
const bcrypt = require('bcryptjs');

// * Models
const Shop = require('../models/shop');
const User = require('../models/user');
const { update } = require('../models/shop');

// Route for shop profile creation by user
module.exports.create_shop = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { name, phone, timings, capacity, address } = req.body;
  try {
    let check = await User.findOne(req.user._id);
    if (check) {
      return res
        .status(400)
        .json({ success: false, message: 'User cannot create a shop' });
    }
    let shops = await Shop.findOne({
      name: req.body.name,
      owner: req.user._id,
    });
    if (shops) {
      return res.status(400).json('Profile for this shop already exists');
    }

    shops = new Shop({
      owner: req.user._id,
      name: req.body.name,
      /* shop_num:shop_num,*/
      phone: phone,
      timings: timings,
      capacity: capacity,
      address: address,
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
  const updates = Object.keys(req.body);
  const allowed = [
    'name',
    'phone',
    'status',
    'timings',
    'capacity',
    'address',
    'inventory',
  ];
  const isValid = updates.every(update => allowed.includes(update));
  console.log(isValid);
  if (isValid == false) {
    return res.status(400).json('You cannot edit this value');
  }
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let shop = await Shop.findOneAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!shop) {
      return res.status(400).json('Shop Profile does not exist');
    }

    await shop.save();
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
    const myshops = await Shop.find({ owner: req.user._id });
    if (!myshops) {
      return res.status(400).json({
        success: false,
        data: 'No shop exist',
      });
    }
    await req.user.populate('shops').execPopulate();
    return res.status(200).json(myshops);
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};

//Route to delete shop profile of a paticular shopkeeper
module.exports.deleteshop = async (req, res) => {
  try {
    console.log(req.user._id);
    const shop = await Shop.findOne({ owner: req.user._id });
    if (!shop) {
      return res.status(400).json({
        success: false,
        data: 'No shop exist',
      });
    }
    await shop.remove();
    return res.status(200).json(shop);
  } catch (err) {
    console.log(err);
    res.status(400).json({ success: false, data: err });
  }
};
