const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
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
  /*shops: [{
    name: String,
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Shop'
  }],*/
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

// Sign JWT and return
shopkeeperSchema.methods.getSignedJwtToken = function() {
  return jwt.sign({ id: this._id }, process.env.JWTTOKEN);
};

const Shopkeeper = mongoose.model('shopkeepers', shopkeeperSchema);
module.exports = Shopkeeper;
