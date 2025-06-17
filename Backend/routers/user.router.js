const router = require("express").Router();
const UserConroller = require("../controllers/user.controller.js");

router.post("/register", UserConroller.register);

module.exports = router;
