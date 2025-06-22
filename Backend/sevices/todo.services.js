const TodoModel = require("../model/todoList.model");

class TodoService {
  static async createTodoList(userId, title, description) {
    const newToDo = new TodoModel({
      userId,
      title,
      description,
    });
    return await newToDo.save();
  }
}

module.exports = TodoService;
