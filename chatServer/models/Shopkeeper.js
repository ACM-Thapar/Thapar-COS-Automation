//  * Utils
const { shopkeeperSchema } = require('../../server/models/shopkeeper');
const { mainDBConnection } = require('../config/db');

const Shopkeeper = mainDBConnection.model('Shopkeeper', shopkeeperSchema);
module.exports = Shopkeeper;
