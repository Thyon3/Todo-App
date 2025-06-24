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
  static async getTodoList(userId) {
    const todo = await TodoModel.find({ userId });
    return todo;
  }
}

module.exports = TodoService;
