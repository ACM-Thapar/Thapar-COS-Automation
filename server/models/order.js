const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema(
  {
    items: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Inventory',
      },
    ],
    createdAt: {
      type: Date,
      default: Date.now,
    },
    placedBy: {
      type: mongoose.Schema.ObjectId,
      ref: 'users',
      required: true,
    },
    shop: {
      type: mongoose.Schema.ObjectId,
      ref: 'shops',
      required: true,
    },
    status: {
      type: String,
      enum: [
        'order_placed',
        'order_confirmed',
        'preparing',
        'out_for_delivery',
        'completed',
      ],
      default: 'order_placed',
    },
    phone: {
      type: String,
    },
    address: {
      type: String,
    },
    paymentType: {
      type: String,
      default: 'COD',
    },
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

const Order = mongoose.model('Order', orderSchema);
module.exports = Order;
