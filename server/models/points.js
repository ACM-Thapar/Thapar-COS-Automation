const mongoose = require('mongoose');

const pointsSchema = new mongoose.Schema(
  {
    points: {
      type: Number,
      default: 0,
    },
    user: {
      type: mongoose.Schema.ObjectId,
      ref: 'users',
      required: true,
    },
    shop: {
      type: mongoose.Schema.ObjectId,
      ref: 'shops',
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

pointsSchema.index({ user: 1, shop: 1 }, { unique: true });

const Points = mongoose.model('Points', pointsSchema);
module.exports = Points;
