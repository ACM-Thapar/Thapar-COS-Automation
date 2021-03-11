const mongoose = require('mongoose');
const { chatDBConnection } = require('../config/db');

const ConversationSchema = new mongoose.Schema(
  {
    participant1: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Shopkeeper',
      required: true,
    },
    participant2: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    lastOpened: {
      type: Date,
      default: new Date(),
    },
  },
  {
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
    // bufferCommands: false, autoCreate: false
  },
);

ConversationSchema.index(
  { participant1: 1, participant2: 1 },
  { unique: true },
);

ConversationSchema.virtual('messages', {
  ref: 'Message',
  localField: '_id',
  foreignField: 'conversationId',
});

module.exports = chatDBConnection.model('Conversation', ConversationSchema);
