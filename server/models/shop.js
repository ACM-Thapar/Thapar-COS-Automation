const mongoose = require('mongoose');
const shopSchema = new mongoose.Schema({
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    require: true,
    ref: 'shopkeepers',
  },
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
  shop_rating:{
      type:Number
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
shopSchema.virtual('members', {
  ref: 'Review', // The model to use
  localField: 'shop_rating', // Find people where `localField`
  foreignField: 'rating', // is equal to `foreignField`
  // If `justOne` is true, 'members' will be a single doc as opposed to
  // an array. `justOne` is false by default.
  justOne: false, 
});
{ toJSON: { virtuals: true } toObject: { virtuals: true } }

const Shop = mongoose.model('shops', shopSchema);
module.exports = Shop;
