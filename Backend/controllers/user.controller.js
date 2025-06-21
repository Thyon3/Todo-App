const UserModel = require("../model/user_model.js");
const userService = require("../sevices/user.service.js");

console.log("generateToken exists?", userService.generateToken);

exports.register = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({
        status: false,
        error: "Email and password are required",
      });
    }
    const newUser = await userService.userRegister(email, password);
    var tokenData = { id: newUser._id, email: newUser.email };

    var token = await userService.generateToken(tokenData, "secreteKey", "1h");
    res.status(201).json({
      status: true,
      token: token,
      message: "the user has been registered succesfully",
    });
    console.log("the user has registerd");
  } catch (e) {
    throw e;
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await userService.checkUser(email);

    if (!user) {
      throw new Error("the User does not exist please Sign up first");
    }
    // if the user exits then check the wherher the password is correct

    const isPasswordCorrect = await user.comparePassword(password);

    if (isPasswordCorrect) {
      let tokenData = { _id: user._id, email: user.email };
      // now lets generate the token we need to login the user

      let token = await userService.generateToken(
        tokenData,
        "secreteKey",
        "1h"
      );
      // send a response for the user
      res.status(200).json({ status: true, token: token });
    } else {
      throw new Error("Invalid Password");
    }
  } catch (e) {
    throw e;
  }
};
