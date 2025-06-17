const mongoose = require("mongoose");
const db = require("../config/db");

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
});

const UserModel = db.model("user", userSchema);
module.exports = UserModel;
