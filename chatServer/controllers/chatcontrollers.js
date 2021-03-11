//  * Utils
const ErrorResponse = require('../../server/utils/errorResponse');

// * Models
const User = require('../models/User');
const Shopkeeper = require('../models/Shopkeeper');
const Message = require('../models/Message');
const Conversation = require('../models/Conversation');

// @desc     Fetch a User from the main db
// @route    GET /chat-api/chat/user/:id
// @access   Public
module.exports.getUser = async (req, res, next) => {
  // const errors = validationResult(req);
  // if (!errors.isEmpty()) {
  //   return res.status(400).json({ errors: errors.array() });
  // }

  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Fetch a Shopkeeper from the main db
// @route    GET /chat-api/chat/shopkeeper/:id
// @access   Public
module.exports.getShopkeeper = async (req, res, next) => {
  // const errors = validationResult(req);
  // if (!errors.isEmpty()) {
  //   return res.status(400).json({ errors: errors.array() });
  // }

  try {
    const shopkeeper = await Shopkeeper.findById(req.params.id);

    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    res.status(200).json({
      success: true,
      data: shopkeeper,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Create a conversation from user to shopkeeper
// @route    POST /chat-api/chat/add-conversation/user/:id
// @access   Private

module.exports.addConversationUser = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    const shopkeeper = await Shopkeeper.findById(req.body.shopkeeperId).lean();
    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    const participants = [user._id, shopkeeper._id];
    //Checking for the existing conversation between the current participants
    const conversation = await Conversation.find({
      participant1: { $in: participants },
      participant2: { $in: participants },
    })
      .populate({ path: 'messages' })
      .exec();

    if (!conversation || conversation.length === 0) {
      let body = {
        participant1: user._id,
        participant2: shopkeeper._id,
      };
      const newconversation = await (await Conversation.create(body)).populate({
        path: 'messages',
      });
      return res.status(200).json({
        success: true,
        data: newconversation,
      });
    }

    res.status(200).json({
      success: true,
      data: conversation,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Create a conversation from shopkeeper to user
// @route    POST /chat-api/chat/add-conversation/shopkeeper/:id
// @access   Private

module.exports.addConversationShopkeeper = async (req, res, next) => {
  try {
    const shopkeeper = await Shopkeeper.findById(req.params.id).lean();
    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    const user = await User.findById(req.body.userId).lean();
    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    const participants = [shopkeeper._id, user._id];
    // Checking for the existing conversation between the current participants
    const conversation = await Conversation.find({
      participant1: { $in: participants },
      participant2: { $in: participants },
    })
      .populate({ path: 'messages' })
      .exec();

    if (!conversation || conversation.length === 0) {
      let body = {
        participant1: shopkeeper._id,
        participant2: user._id,
      };
      const newconversation = await (await Conversation.create(body)).populate({
        path: 'messages',
      });
      return res.status(200).json({
        success: true,
        data: newconversation,
      });
    }

    res.status(200).json({
      success: true,
      data: conversation,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Get all User's Conversation
// @route    GET /chat-api/chat/my-conversation/user/:id
// @access   Private

module.exports.getConversationUser = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).lean();
    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    const conversations = await Conversation.find({
      $or: [{ participant1: req.params.id }, { participant2: req.params.id }],
    }).lean();

    res.status(200).json({
      success: true,
      data: conversations,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Get all Shopkeeper's Conversation
// @route    GET /chat-api/chat/my-conversation/shopkeeper/:id
// @access   Private

module.exports.getConversationShopkeeper = async (req, res, next) => {
  try {
    const shopkeeper = await Shopkeeper.findById(req.params.id).lean();
    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    const conversations = await Conversation.find({
      $or: [{ participant1: req.params.id }, { participant2: req.params.id }],
    }).lean();

    res.status(200).json({
      success: true,
      data: conversations,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Get a Conversation by ID (user)
// @route    GET /chat-api/chat/conversation/user/:id
// @access   Private

module.exports.getConversationByIdUser = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).lean();
    if (!user) {
      return next(new ErrorResponse('User does not exist', 400));
    }
    const conversation = await Conversation.findById(req.body.conversationID)
      .populate({ path: 'messages' })
      .populate({ path: 'participant1', select: 'name email' })
      .populate({ path: 'participant2', select: 'name email' })
      .exec();

    if (!conversation) {
      return next(new ErrorResponse('No conversation found', 400));
    }
    // Check if the user accessing the conversation is a part of the same
    if (
      !conversation.participant1._id.equals(req.params.id) &&
      !conversation.participant2._id.equals(req.params.id)
    ) {
      return next(new ErrorResponse('Not authorised to view this', 401));
    }

    res.status(200).json({
      success: true,
      data: conversation,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};

// @desc     Get a Conversation by ID (shopkeeper)
// @route    GET /chat-api/chat/conversation/shopkeeper/:id
// @access   Private

module.exports.getConversationByIdShopkeeper = async (req, res, next) => {
  try {
    const shopkeeper = await Shopkeeper.findById(req.params.id).lean();
    if (!shopkeeper) {
      return next(new ErrorResponse('Shopkeeper does not exist', 400));
    }
    const conversation = await Conversation.findById(req.body.conversationID)
      .populate({ path: 'messages' })
      .populate({ path: 'participant1', select: 'name email' })
      .populate({ path: 'participant2', select: 'name email' })
      .exec();

    if (!conversation) {
      return next(new ErrorResponse('No conversation found', 400));
    }
    // Check if the shopkeeper accessing the conversation is a part of the same
    if (
      !conversation.participant1._id.equals(req.params.id) &&
      !conversation.participant2._id.equals(req.params.id)
    ) {
      return next(new ErrorResponse('Not authorised to view this', 401));
    }

    res.status(200).json({
      success: true,
      data: conversation,
    });
  } catch (err) {
    console.log(err);
    return next(new ErrorResponse('Server error', 500));
  }
};
