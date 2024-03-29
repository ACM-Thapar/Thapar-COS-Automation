const mongoose = require('mongoose');
const shopSchema = new mongoose.Schema(
  {
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: 'shopkeepers',
    },
    name: {
      type: String,
      required: true,
    },
    category: {
      type: String,
      required: true,
      enum: ['departmental', 'stationary', 'eateries'],
    },
    phone: {
      type: Number,
      required: true,
      minlength: 10,
      maxlength: 10,
    },
    status: {
      type: String,
      default: 'OPEN',
    },
    timings: {
      startTime: Date,
      endTime: Date,
    },
    address: {
      type: String,
      default: 'COS Complex',
    },
    capacity: {
      type: Number,
      default: null,
    },
    shop_rating: {
      type: Number,
    },
    photo: {
      type: String,
      default: null,
    },
    averageRating: {
      type: Number,
      default: null,
    },
    itemCategories: [
      {
        type: String,
        trim: true,
      },
    ],
  },
  { toJSON: { virtuals: true }, toObject: { virtuals: true } },
);

shopSchema.index({ owner: 1 });

shopSchema.virtual('members', {
  ref: 'Review',
  localField: 'shop_rating',
  foreignField: 'rating',
  justOne: false,
});

shopSchema.virtual('inventory', {
  ref: 'Inventory',
  localField: '_id',
  foreignField: 'shop',
  justOne: false,
});

shopSchema.pre('remove', async function (next) {
  console.log('Inventory being cleared...');
  await this.model('Inventory').deleteMany({ shop: this._id });
  next();
});

const Shop = mongoose.model('shops', shopSchema);
module.exports = Shop;
