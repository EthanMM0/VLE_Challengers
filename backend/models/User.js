// ./models/User.js

const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// User Schema
const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  valorantUsername: { type: String, default: null }, // Optional at registration
  valorantTag: { type: String, default: null }, 
  valorantRank: { type: String, default: null },      // Optional at registration
}, { timestamps: true });

// Hash Password before saving
UserSchema.pre('save', async function(next) {
  if (this.isModified('password') || this.isNew) {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
  }
  next();
});

// Compare Password Method (optional but useful for any manual password comparison)
UserSchema.methods.comparePassword = function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// Create the model
module.exports = mongoose.model('User', UserSchema);
