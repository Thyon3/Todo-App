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
