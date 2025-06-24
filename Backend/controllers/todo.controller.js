const UserServices = require("../sevices/todo.services");

exports.createTodo = async (req, res, next) => {
  try {
    // extract the user inputs from the request body
    const { userId, title, description } = req.body;
    const newToDo = await UserServices.createTodoList(
      userId,
      title,
      description
    );
    res.json({ status: true, success: newToDo });
  } catch (error) {
    next(error);
  }
};

exports.getToDo = async (req, res, next) => {
  try {
    // extract the user inputs from the request body
    const { userId } = req.body;
    const todo = await UserServices.getTodoList(userId);
    res.json({ status: true, success: todo });
  } catch (error) {
    next(error);
  }
};
