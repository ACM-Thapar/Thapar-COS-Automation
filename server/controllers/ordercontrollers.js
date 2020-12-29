// * Utils
const { check, validationResult } = require('express-validator');

// * Models
const Order = require('../models/order');
const Shop = require('../models/shop');
const Inventory = require('../models/inventory');

// @desc     Add an order
// @route    POST /api/order/add-order/:id
// @access   Private
module.exports.addOrder = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const shop = await Shop.findById(req.params.id).lean();
    if (!shop) {
      return res
        .status(400)
        .json({ success: false, message: "Shop doesn't exist" });
    }
    // Printing item name & price
    for (const item of req.body.items) {
      let inventory = await Inventory.findById(item);
      if (!inventory) {
        return res
          .status(400)
          .json({ success: false, message: 'Product id invalid' });
      } else if (!inventory.shop.equals(shop._id)) {
        // Check if the inventory item belongs to the store
        return res
          .status(400)
          .json({ success: false, message: 'Invalid Request' });
      }
      console.log(inventory.name, inventory.price);
    }

    let value = { ...req.body, placedBy: req.user._id, shop: req.params.id };

    const order = await Order.create(value);
    res.status(200).json({
      success: true,
      body: order,
    });
  } catch (err) {
    console.log(err);
    res.status(400).json({
      success: false,
      data: err,
    });
  }
};

// @desc     View an order
// @route    GET /api/order/view-order/:id
// @access   Private
module.exports.viewOrder = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let order = await Order.findById(req.params.id)
      .populate({
        path: 'shop',
        select: 'name',
      })
      .populate({
        path: 'items',
        select: 'name photo price',
      });
    if (!order) {
      return res
        .status(400)
        .json({ success: false, message: "Order doesn't exist" });
    }
    res.status(200).json({
      success: true,
      data: order,
    });
  } catch (err) {
    console.log(err);
    res.status(400).json({
      success: false,
      data: err,
    });
  }
};

// @desc    View all orders
// @route   GET /api/v1/order/view-all-orders
// @access  Private
module.exports.viewAllOrders = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    const orders = await Order.find({ placedBy: req.user._id }).populate({
      path: 'shop',
      select: 'name',
    });
    return res.status(200).json({
      success: true,
      count: orders.length,
      data: orders,
    });
  } catch (err) {
    console.log(err);
    res.status(400).json({
      success: false,
      data: err,
    });
  }
};

// @desc     Update an order (user)
// @route    PUT /api/order/update-order-user/:id
// @access   Private
module.exports.updateOrderUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body };
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return res
        .status(404)
        .json({ success: false, message: "Order doesn't exist" });
    }
    // Check if the person updating the order is the one who placed it
    if (!order.placedBy.equals(req.user._id) || req.body.status) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    order = await Order.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    });
    res.status(200).json({ success: true, data: order });
  } catch (err) {
    console.log(err);
    res.status(500).send('Server error');
  }
};

// @desc     Update an order (shopkeeper)
// @route    PUT /api/order/update-order-shopkeeper/:id
// @access   Private
module.exports.updateOrderShopkeeper = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body };
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return res
        .status(404)
        .json({ success: false, message: "Order doesn't exist" });
    }
    let shop = await Shop.findById(order.shop).lean();
    // Check if the person updating the order is the owner of that shop
    if (!shop.owner.equals(req.user._id)) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    order = await Order.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    });
    res.status(200).json({ success: true, data: order });
  } catch (err) {
    console.log(err);
    res.status(500).send('Server error');
  }
};

// @desc     Delete order (user)
// @route    DELETE /api/order/delete-order-user/:id
// @access   Private
module.exports.deleteOrderUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let order = await Order.findById(req.params.id).lean();

    // Check if the order exists
    if (!order) {
      return res
        .status(404)
        .json({ success: false, message: "Order doesn't exist" });
    }
    // Check if the person deleting the order is the one who placed it
    if (!order.placedBy.equals(req.user._id)) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    order = await Order.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'Deleted sucessfully' });
  } catch (err) {
    console.log(err);
    res.status(500).send('Server error');
  }
};

// @desc     Delete order (shopkeeper)
// @route    DELETE /api/order/delete-order-shopkeeper/:id
// @access   Private
module.exports.deleteOrderShopkeeper = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return res
        .status(404)
        .json({ success: false, message: "Order doesn't exist" });
    }
    let shop = await Shop.findById(order.shop).lean();
    // Check if the person deleting the order is the owner of that shop
    if (!shop.owner.equals(req.user._id)) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    order = await Order.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'Deleted sucessfully' });
  } catch (err) {
    console.log(err);
    res.status(500).send('Server error');
  }
};
