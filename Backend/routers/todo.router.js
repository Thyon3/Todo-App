const TodoController = require("../controllers/todo.controller");

const express = require("express");
const routers = express.Router();

routers.post("/createTodoList", TodoController.createTodo);
routers.get("/getTodoList", TodoController.getToDo);

module.exports = routers;
