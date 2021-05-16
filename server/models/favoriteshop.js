const mongoose = require('mongoose');

const favoriteshopSchema = new mongoose.Schema({
  shopDetails: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'shops',
    require: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'users',
    require: true,
  },
  created_at: {
    type: Date,
    default: Date.now,
    required: true,
  },
});

// favoriteshopSchema.index({ shopDetails: 1, user: 1 });
favoriteshopSchema.index({ user: 1, shopDetails: 1 });

const Favoriteshop = mongoose.model('favoriteshops', favoriteshopSchema);
module.exports = Favoriteshop;
