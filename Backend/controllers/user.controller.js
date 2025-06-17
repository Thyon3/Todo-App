const userService = require("../sevices/user.service");

exports.register = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({
        status: false,
        error: "Email and password are required",
      });
    }
    const successResponse = await userService.userRegister(email, password);
    res.status(201).json({
      status: true,
      success: "the user has been registered succesfully",
    });
    console.log("the user has registerd");
  } catch (e) {
    throw e;
  }
};
