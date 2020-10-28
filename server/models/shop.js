const mongoose = require('mongoose');
const shopSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    require: true,
    ref: 'shopkeepers',
  },
  /*shop_num:
  {
    type: String,
    required: true,
  },*/
  name: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: false,
  },
  phone: {
    type: Number,
    required: true,
    minlength: 10,
    maxlength: 10,
  },
  status: {
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
  review: [
    {
      rating: {
        type: Number,
        min: 0,
        max: 5,
      },
      text: {
        type: String,
      },
    },
  ],
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
const Shop = mongoose.model('shops', shopSchema);
module.exports = Shop;
