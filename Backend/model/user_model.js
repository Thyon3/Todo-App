const mongoose = require("mongoose");
const db = require("../config/db");
const bcrpt = require("bcrypt");

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
userSchema.pre("save", async function () {
  try {
    const user = this;
    const salt = await bcrpt.genSalt(10);
    const hashPass = await bcrpt.hash(user.password, salt);

    user.password = hashPass;
  } catch (e) {
    throw e;
  }
});

const UserModel = db.model("user", userSchema);
module.exports = UserModel;
