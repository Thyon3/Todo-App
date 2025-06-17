const mongoose = require("mongoose");
const DB_URI =
  "mongodb+srv://flutter_user:ASNTHY3693@todoapp.7xurprt.mongodb.net/?retryWrites=true&w=majority&appName=TodoAppUsersDb";

const connection = mongoose
  .connect(DB_URI)
  .then(() => console.log("connected succcesfully"))
  .catch((err) => console.error("failed connection", err));

module.exports = mongoose;
