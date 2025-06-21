const mongoose = require("mongoose");
const db = require("../config/db");
const UserModel = require("../model/user_model.js");

// create the schema for the todo items we are going to have

const todoListSchema = new mongoose.Schema({
  userId: {
    type:mongoose.Schema.Types.ObjectId,
    ref: UserModel.modelName,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
});

// now create the model or the collection in Mongodb and export it
const TodoModel = mongoose.model("TodoListModel", todoListSchema);
module.exports = TodoModel; 