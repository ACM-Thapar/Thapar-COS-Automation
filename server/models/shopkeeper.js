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
  // Added otp
  otp: {
    code: {
      type: String,
      required: true,
      trim: true,
    },
    validity: {
      type: Date,
      default: new Date(Date.now() + 15 * 60 * 1000),
    },
  },
  verified: {
    type: Boolean,
    default: false,
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

// Match otp entered by the shopkeeper with otp stored in the database
shopkeeperSchema.methods.matchOtp = function(enteredOtp) {
  if (enteredOtp !== this.otp.code) {
    return false;
  }
  return true;
};

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
