// * Utils
const { check, validationResult } = require('express-validator');
const ErrorResponse = require('../utils/errorResponse');

// * Models
const Order = require('../models/order');
const Shop = require('../models/shop');
const Inventory = require('../models/inventory');
const Points = require('../models/points');

// @desc     Add an order
// @route    POST /api/order/add-order/:id
// @access   Private
module.exports.addOrder = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const [shop, pointsSchema] = await Promise.all([
      Shop.findById(req.params.id).lean().exec(),
      Points.findOne({ user: req.user._id, shop: req.params.id }).lean().exec(),
    ]);
    let pointsObj;
    // const shop = await Shop.findById(req.params.id).lean();
    if (!shop) {
      // * Throw error if shop doesn't exists
      return next(new ErrorResponse('Shop does not exist', 400));
    }
    if (!pointsSchema) {
      // * Creating a points schema corresponding to a user and shop
      const body = { user: req.user._id, shop: shop._id };
      pointsObj = await Points.create(body);
    }
    if (pointsSchema) {
      pointsObj = pointsSchema;
    }
    let totalAmount = 0;
    // Printing item name & price
    for (const item of req.body.items) {
      let inventory = await Inventory.findById(item).lean().exec();
      if (!inventory) {
        return next(new ErrorResponse('Product does not exist', 400));
      } else if (!inventory.shop.equals(shop._id)) {
        // Check if the inventory item belongs to the store
        return next(new ErrorResponse('Invalid request', 400));
      }
      console.log(inventory.name, inventory.price);
      totalAmount = totalAmount + inventory.price;
    }
    let discountedAmount = 0;
    let pointsEarned = 0;
    let pointsUsed = 0;
    if (shop.category === 'departmental' || shop.category === 'stationary') {
      pointsUsed = Math.round(pointsObj.points * 0.9);
      const discount = pointsUsed / 100;
      discountedAmount = totalAmount - discount;
      pointsEarned = Math.round(totalAmount * 0.9);
    }
    if (shop.category === 'eateries') {
      pointsUsed = Math.round(pointsObj.points * 0.9);
      const discount = pointsUsed / 100;
      discountedAmount = totalAmount - discount;
      pointsEarned = Math.round((totalAmount * 10) / 75);
    }
    let value = {
      ...req.body,
      placedBy: req.user._id,
      shop: req.params.id,
      totalAmount: totalAmount,
      discountedAmount: discountedAmount,
      pointsEarned: pointsEarned,
      pointsUsed: pointsUsed,
    };
    const newPoints = pointsObj.points - pointsUsed + pointsEarned;
    const [order, newPointsObj] = await Promise.all([
      Order.create(value),
      Points.findByIdAndUpdate(
        pointsObj._id,
        { points: newPoints, updatedAt: Date.now() },
        { new: true },
      ),
    ]);
    if (newPointsObj) {
      console.log(newPointsObj, 'points details');
    }
    res.status(200).json({
      success: true,
      body: order,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     View an order
// @route    GET /api/order/view-order/:id
// @access   Private
module.exports.viewOrder = async (req, res, next) => {
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
      return next(new ErrorResponse('Order does not exist', 400));
    }
    res.status(200).json({
      success: true,
      data: order,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc    View all orders
// @route   GET /api/v1/order/view-all-orders
// @access  Private
module.exports.viewAllOrders = async (req, res, next) => {
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
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Update an order (user)
// @route    PUT /api/order/update-order-user/:id
// @access   Private
module.exports.updateOrderUser = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body };
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return next(new ErrorResponse('Order does not exist', 404));
    }
    // Check if the person updating the order is the one who placed it
    if (!order.placedBy.equals(req.user._id) || req.body.status) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    order = await Order.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    });
    res.status(200).json({ success: true, data: order });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Update an order (shopkeeper)
// @route    PUT /api/order/update-order-shopkeeper/:id
// @access   Private
module.exports.updateOrderShopkeeper = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body };
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return next(new ErrorResponse('Order does not exist', 404));
    }
    let shop = await Shop.findById(order.shop).lean();
    // Check if the person updating the order is the owner of that shop
    if (!shop.owner.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    order = await Order.findByIdAndUpdate(req.params.id, body, {
      runValidators: false,
      new: true,
    });
    res.status(200).json({ success: true, data: order });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Delete order (user)
// @route    DELETE /api/order/delete-order-user/:id
// @access   Private
module.exports.deleteOrderUser = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let order = await Order.findById(req.params.id).lean();

    // Check if the order exists
    if (!order) {
      return next(new ErrorResponse('Order does not exist', 404));
    }
    // Check if the person deleting the order is the one who placed it
    if (!order.placedBy.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    order = await Order.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'Deleted sucessfully' });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Delete order (shopkeeper)
// @route    DELETE /api/order/delete-order-shopkeeper/:id
// @access   Private
module.exports.deleteOrderShopkeeper = async (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let order = await Order.findById(req.params.id).lean();
    // Check if the order exists
    if (!order) {
      return next(new ErrorResponse('Order does not exist', 404));
    }
    let shop = await Shop.findById(order.shop).lean();
    // Check if the person deleting the order is the owner of that shop
    if (!shop.owner.equals(req.user._id)) {
      return next(
        new ErrorResponse('Not authorized to perform this action', 401),
      );
    }
    order = await Order.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, message: 'Deleted sucessfully' });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};
