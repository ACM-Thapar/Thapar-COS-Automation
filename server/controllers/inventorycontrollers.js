// * Utils
const { validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

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
      return ErrorResponse(
        res,
        `Shop with the id ${req.params.id} does not exist`,
        400,
      );
    }
    // Check if the person adding the inventory is the owner of the shop
    if (!shop.owner.equals(req.user.id)) {
      return ErrorResponse(res, 'Not authorized to perform this action', 401);
    }
    const newCategory = req.body.category.toUpperCase();
    if (!shop.itemCategories) {
      return ErrorResponse(
        res,
        'Please add a item category for shop first',
        400,
      );
    }
    if (!shop.itemCategories.includes(newCategory)) {
      return ErrorResponse(
        res,
        'Please enter a valid item category. If you want to add a product in this category, please create the category first',
        400,
      );
    }
    let newBody = {
      ...body,
      shop: shop._id,
      shopOwner: req.user.id,
      category: newCategory,
    };
    const inventoryItem = await Inventory.create(newBody);
    res.status(200).json({ success: true, data: inventoryItem });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'Product does not exist', 404);
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return ErrorResponse(res, 'Not authorized to perform this action', 401);
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
    return ErrorResponse(res, 'Server error', 500);
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
      return ErrorResponse(res, 'Product does not exist', 404);
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return ErrorResponse(res, 'Not authorized to perform this action', 401);
    }
    inventory = await Inventory.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    }).exec();
    res.status(200).json({ success: true, data: inventory });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};

// @desc     Delete a product from inventory
// @route    DELETE /api/inventory/delete-product/:id
// @access   Private
module.exports.deleteInventoryProduct = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    // TODO Remove image from Cloud if possible
    let inventory = await Inventory.findById(req.params.id).lean();
    // Check if the product exists
    if (!inventory) {
      return ErrorResponse(res, 'Product does not exist', 404);
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return ErrorResponse(res, 'Not authorized to perform this action', 401);
    }
    inventory = await Inventory.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'deleted sucessfully' });
  } catch (err) {
    console.log(err);
    return ErrorResponse(res, 'Server error', 500);
  }
};
