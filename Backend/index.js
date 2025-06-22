const express = require("express");
const app = express();

const db = require("./config/db");
const userModel = require("./model/user_model.js");
const bodyParser = require("body-parser");
const userRouter = require("./routers/user.router.js");
const todoListRouter = require("./routers/todo.router.js");
//
const todoModel = require("./model/todoList.model.js");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(bodyParser.json());
app.use("/", userRouter);
app.use("/", todoListRouter);
app.get("/", (req, res) => {
  res.send("Hello world hhh");
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}/`);
});
