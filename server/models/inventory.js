const mongoose = require('mongoose');
const inventory = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Please add a name'],
      trim: true,
    },
    photo: {
      type: String,
      required: [true, 'Please add a photo'],
    },
    price: {
      type: Number,
      required: [true, 'Please add a price for the item'],
      trim: true,
    },
    outOfStock: {
      type: Boolean,
      default: false,
    },
    shop: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'shops',
    },
    shopOwner: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'shopkeepers',
    },
  },
  { toJSON: { virtuals: true }, toObject: { virtuals: true } },
);

inventory.index({ shop: 1 });

const Inventory = mongoose.model('Inventory', inventory);
module.exports = Inventory;
