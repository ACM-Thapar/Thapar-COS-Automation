// * Utils
const { check, validationResult } = require('express-validator');

// * NPM Packages

// * Models
const Shop = require('../models/shop');
const Inventory = require('../models/inventory');

// @desc     Add a product to inventory
// @route    POST /api/inventory/add-inventory/:id
// @access   Private
module.exports.addInventory = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body, photo: req.file.url };
    const shop = await Shop.findById(req.params.id).lean();
    if (!shop) {
      return res.status(400).json({
        success: false,
        message: `Shop with the id ${req.params.id} doesn't exist`,
      });
    }
    console.log(shop, 'shop');
    // Check if the person adding the inventory is the owner of the shop
    if (!shop.owner.equals(req.user.id)) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    let newBody = { ...body, shop: shop._id, shopOwner: req.user.id };
    const inventoryItem = await Inventory.create(newBody);
    res.status(200).json({ success: true, data: inventoryItem });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Update a product's availability status in inventory
// @route    PUT /api/inventory/update-availability/:id
// @access   Private
module.exports.markInventoryAvailablity = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let inventory = await Inventory.findById(req.params.id).lean();
    // Check if the product exists
    if (!inventory) {
      return res
        .status(404)
        .json({ success: false, message: "Product doesn't exist" });
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return res.status(401).json({
        success: false,
        message: 'Not authorised to perform this action',
      });
    }
    inventory = await Inventory.findByIdAndUpdate(
      req.params.id,
      {
        outOfStock: !inventory.outOfStock,
      },
      { runValidators: false, new: true },
    ).exec();
    res.status(200).json({ success: true, data: inventory });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};

// @desc     Update a product's details in inventory
// @route    PUT /api/inventory/update-product/:id
// @access   Private
module.exports.updateInventoryProduct = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    // TODO Remove Old image from Cloud if possible
    let body = { ...req.body };
    if (req.file) {
      body = { ...body, photo: req.file.url };
    }

    let inventory = await Inventory.findById(req.params.id).lean();
    // Check if the product exists
    if (!inventory) {
      return res
        .status(404)
        .json({ success: false, message: "Product doesn't exist" });
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return res.status(401).json({
        success: false,
        message: 'Not authorised to perform this action',
      });
    }
    inventory = await Inventory.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    }).exec();
    res.status(200).json({ success: true, data: inventory });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};
