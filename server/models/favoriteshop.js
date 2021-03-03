const mongoose = require('mongoose');
const favoriteshopSchema = new mongoose.Schema({
  created_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
  shopDetails: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Shop',
    require: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    require: true,
  },
});

const Favoriteshop = mongoose.model('favoriteshops', favoriteshopSchema);
module.exports = Favoriteshop;
