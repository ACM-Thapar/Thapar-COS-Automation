const mongoose = require('mongoose');
const shop = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  category: {
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
  shop_num: {
    type: Number,
    required: true,
  },
  shop: {
    type: String,
    id: String,
  },
  staus: {
    type: String,
    default: 'OPEN',
  },
  timings: {
    startTime: Date,
    endTime: Date,
  },
  address: {
    type: String,
    default: 'COS Complex',
  },
  capacity: {
    type: Number,
    default: '',
  },
  //array of objects
  inventory: [
    {
      category: {
        type: String,
      },
      items: [
        {
          avalibility: {
            type: String,
            default: 'available',
          },
          price: {
            type: Number,
            required: true,
          },
        },
      ],
    },
  ],
});
const Shop = mongoose.model('shops', shopschema);
module.exports = Shop;
