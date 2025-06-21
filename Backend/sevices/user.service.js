const userModel = require("../model/user_model");
const jwt = require("jsonwebtoken");
class UserService {
  static async userRegister(email, password) {
    // create the user and save it on the database

    try {
      const newUser = new userModel({ email, password });
      return newUser.save();
    } catch (e) {
      throw e;
    }
  }

  static async checkUser(email) {
    try {
      // reurn the user with the provided email
      return await userModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }

  static async generateToken(tokenData, secreteKey, expiryTime) {
    var token = jwt.sign(tokenData, secreteKey, {
      expiresIn: expiryTime,
    });
    return token; // ✅ fixed
  }
}

module.exports = UserService;
