const app = require("./app");
const db = require("./config/db");

app.get("/", (req, res) => {
  res.send("Hello world hhh");
});
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}/`);
});
