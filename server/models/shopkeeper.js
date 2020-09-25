const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const shopkeeperSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: Number,
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
  isGoogleUser: {
    type: Boolean,
    default: false,
  },
});

// Encrypt password using bcrypt
shopkeeperSchema.pre('save', async function(next) {
  // Check if the password is modified or not, if it is not then move along, don't perform the hashing stuff
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

const Shopkeeper = mongoose.model('shopkeepers', shopkeeperSchema);
module.exports = Shopkeeper;
