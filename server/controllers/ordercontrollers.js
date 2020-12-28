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

    // Printing item name & price
    try {
        let inventory;
        req.body.items.forEach(async (item) => {
            inventory = await Inventory.findById(item);
            console.log(inventory.name, inventory.price);
        });

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
      let order = await Order.findById(req.params.id).populate({
        path: 'shop',
        select: 'name'
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
        const orders = await Order.find({ placedBy: req.user._id });
        return res.status(200).json({
            success: true,
            count: orders.length,
            data: orders
        });
    } catch (err) {
        console.log(err);
        res.status(400).json({
          success: false,
          data: err,
        });
    }
};
  
// @desc     Update an order
// @route    PUT /api/order/update-order/:id
// @access   Private
module.exports.updateOrder = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    try {
      let body = { ...req.body };
      let order = await Order.findById(req.params.id);
      // Check if the order exists
      if (!order) {
        return res
          .status(404)
          .json({ success: false, message: "Order doesn't exist" });
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

// @desc     Delete order
// @route    DELETE /api/order/delete-order/:id
// @access   Private
module.exports.deleteOrder = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    try {
      let order = await Order.findById(req.params.id);
      // Check if the order exists
      if (!order) {
        return res
          .status(404)
          .json({ success: false, message: "Order doesn't exist" });
      }
      order = await Order.findByIdAndDelete(req.params.id);
      res.status(200).json({ success: true, message: 'Deleted sucessfully' });
    } catch (err) {
      console.log(err);
      res.status(500).send('Server error');
    }
  };