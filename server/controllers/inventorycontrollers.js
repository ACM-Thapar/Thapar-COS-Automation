// * Utils
const { check, validationResult } = require('express-validator');

// * NPM Packages

// * Models
const Shop = require('../models/shop');
const Inventory = require('../models/inventory');

// Route for shop profile creation by user
module.exports.addInventory = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    let body = { ...req.body, photo: req.file.url };
    const shop = await Shop.findById(req.params.id).exec();
    if (!shop) {
      return res.status(400).json({
        success: false,
        message: `Shop with the id ${req.params.id} doesn't exist`,
      });
    }
    console.log(shop, 'shop');
    // Check if the person adding the inventory is the owner of the shop
    if (!shop.owner.equals(req.user.id)) {
      return res.status(401).json({
        success: false,
        message: 'Not Authorised to perform this action',
      });
    }
    let newBody = { ...body, shop: shop._id, shopOwner: req.user.id };
    const inventoryItem = await Inventory.create(newBody);
    res.status(200).json({ success: true, data: inventoryItem });
  } catch (err) {
    console.log(err);
    res.status(500).send('server error');
  }
};
