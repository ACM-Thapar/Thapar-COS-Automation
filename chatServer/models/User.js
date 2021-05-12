//  * Utils
const { userSchema } = require('../../server/models/user');
const { mainDBConnection } = require('../config/db');

const User = mainDBConnection.model('User', userSchema);
module.exports = User;
