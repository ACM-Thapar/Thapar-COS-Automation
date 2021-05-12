const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const userSchema = new mongoose.Schema({
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
    required: true,
    type: String,
    unique: true,
    trim: true,
  },
  password: {
    required: true,
    type: String,
    trim: true,
  },

  // Added otp
  otp: {
    code: {
      type: String,
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
  hostel: {
    type: String,
    trim: true,
  },
  isGoogleUser: {
    type: Boolean,
    default: false,
  },
  isPhoneVerified: {
    type: Boolean,
    default: false,
  },
});

// Match otp entered by the user with otp stored in the database
userSchema.methods.matchOtp = function (enteredOtp) {
  if (enteredOtp !== this.otp.code) {
    return false;
  }
  return true;
};

// Encrypt password using bcrypt
userSchema.pre('save', async function (next) {
  // Check if the password is modified or not, if it is not then move along, don't perform the hashing stuff
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Sign JWT and return
userSchema.methods.getSignedJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWTTOKEN);
};

// Check if the profile is complete with all the relevant details or not!
userSchema.virtual('isCompleted').get(function () {
  if (
    this.name !== undefined &&
    this.phone !== undefined &&
    this.email !== undefined &&
    this.password !== undefined &&
    this.hostel !== undefined
  ) {
    return true;
  } else {
    return false;
  }
});

const User = mongoose.model('users', userSchema);
module.exports = { User, userSchema };
