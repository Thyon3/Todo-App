const express = require("express");
const app = express();

const db = require("./config/db");
const userModel = require("./model/user_model.js");
const bodyParser = require("body-parser");
const routers = require("./routers/user.router.js");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(bodyParser.json());
app.use("/", routers);
app.get("/", (req, res) => {
  res.send("Hello world hhh");
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}/`);
});
