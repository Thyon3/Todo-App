const router = require("express").Router();
const UserConroller = require("../controllers/user.controller.js");

router.post("/register", UserConroller.register);
router.post("/login", UserConroller.login);

module.exports = router;
