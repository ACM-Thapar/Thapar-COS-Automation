// * Utils
const { check, validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

// * NPM Packages

// * Models
const Shop = require('../models/shop');
const Inventory = require('../models/inventory');

// @desc     Add a product to inventory
// @route    POST /api/inventory/add-inventory/:id
// @access   Private
module.exports.addInventory = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body, photo: req.file.url };
    const shop = await Shop.findById(req.params.id).lean();
    if (!shop) {
      return next(
        new ErrorResponse(
          `Shop with the id ${req.params.id} does not exist`,
          400,
        ),
      );
    }
    console.log(shop, 'shop');
    // Check if the person adding the inventory is the owner of the shop
    if (!shop.owner.equals(req.user.id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    let newBody = { ...body, shop: shop._id, shopOwner: req.user.id };
    const inventoryItem = await Inventory.create(newBody);
    res.status(200).json({ success: true, data: inventoryItem });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Update a product's availability status in inventory
// @route    PUT /api/inventory/update-availability/:id
// @access   Private
module.exports.markInventoryAvailablity = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let inventory = await Inventory.findById(req.params.id).lean();
    // Check if the product exists
    if (!inventory) {
      return next(new ErrorResponse('Product does not exist', 404));
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
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
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Update a product's details in inventory
// @route    PUT /api/inventory/update-product/:id
// @access   Private
module.exports.updateInventoryProduct = async (req, res, next) => {
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
      return next(new ErrorResponse('Product does not exist', 404));
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    inventory = await Inventory.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    }).exec();
    res.status(200).json({ success: true, data: inventory });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Delete a product from inventory
// @route    DELETE /api/inventory/delete-product/:id
// @access   Private
module.exports.deleteInventoryProduct = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    // TODO Remove image from Cloud if possible
    let inventory = await Inventory.findById(req.params.id).lean();
    // Check if the product exists
    if (!inventory) {
      return next(new ErrorResponse('Product does not exist', 404));
    }
    // Check if the current user is the owner
    if (!inventory.shopOwner.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    inventory = await Inventory.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'deleted sucessfully' });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};
