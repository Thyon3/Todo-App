const userModel = require("../model/user_model");
class userService {
  static async userRegister(email, password) {
    // create the user and save it on the database

    try {
      const newUser = new userModel({ email, password });
      return newUser.save();
    } catch (e) {
      throw e;
    }
  }
}

module.exports = userService;
