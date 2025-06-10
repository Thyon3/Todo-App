const mogoose = require("mongoose");
const db = require("../config/db");
const { default: mongoose } = require("mongoose");

const { schema } = mongoose;

const userSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
    unique: true,
  },
});
