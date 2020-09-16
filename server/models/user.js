const mongoose = require('mongoose');
const userSchema = new mongoose.Schema({
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
    unique: true,
    trim: true,
  },
  password: {
    type: String,
    trim: true,
  },
  hostel: {
    type: String,
    trim: true,
  },
});

const User = mongoose.model('users', userSchema);
module.exports = User;
