const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const shopkeeperSchema = new mongoose.Schema(
  {
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
    isGoogleUser: {
      type: Boolean,
      default: false,
    },
    isPhoneVerified: {
      type: Boolean,
      default: false,
    },
  },
  { toJSON: { virtuals: true }, toObject: { virtuals: true } },
);

shopkeeperSchema.virtual('shops', {
  ref: 'shops', // The model to use
  localField: '_id', // Find people where `localField`
  foreignField: 'owner', // is equal to `foreignField`
  // If `justOne` is true, 'members' will be a single doc as opposed to
  // an array. `justOne` is false by default.
  justOne: false,
});

// Match otp entered by the shopkeeper with otp stored in the database
shopkeeperSchema.methods.matchOtp = function (enteredOtp) {
  if (enteredOtp !== this.otp.code) {
    return false;
  }
  return true;
};

// Encrypt password using bcrypt
shopkeeperSchema.pre('save', async function (next) {
  // Check if the password is modified or not, if it is not then move along, don't perform the hashing stuff
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Sign JWT and return
shopkeeperSchema.methods.getSignedJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWTTOKEN);
};

// Check if the profile is complete with all the relevant details or not!
shopkeeperSchema.virtual('isCompleted').get(function () {
  if (
    this.name !== undefined &&
    this.phone !== undefined &&
    this.email !== undefined &&
    this.password !== undefined
  ) {
    return true;
  } else {
    return false;
  }
});

const Shopkeeper = mongoose.model('shopkeepers', shopkeeperSchema);
module.exports = Shopkeeper;
