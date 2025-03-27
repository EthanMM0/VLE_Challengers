// models/ValUserData.js
const mongoose = require('mongoose');

const valUserDataSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  valorantUsername: {
    type: String,
    required: true,
  },
  valorantTag: {
    type: String,
    required: true,
  },
  rank: {
    type: String,
    default: 'Unranked',
  },
});

const ValUserData = mongoose.model('ValUserData', valUserDataSchema);

module.exports = ValUserData;
