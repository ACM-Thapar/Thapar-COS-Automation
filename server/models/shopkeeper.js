const mongoose = require('mongoose');
const shopkeeperSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: Number,
    required: true,
    minlength: 10,
    maxlength: 10,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    trim: true,
    minlength: 4,
  },
  shop: {
    type: String,
    id: String,
  },
});
const Shopkeeper = mongoose.model('shopkeepers', shopkeeperSchema);
module.exports = Shopkeeper;
