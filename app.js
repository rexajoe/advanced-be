import express from "express";
import {
  getUsers,
  getUser,
  updateUser,
  deleteUser,
  createUser,
} from "./database.js";

const app = express();
app.use(express.json());

//Get all users
app.get("/chillmovie/users", async (req, res) => {
  const users = await getUsers();
  res.send(users);
});

//Get user
app.get(`/chillmovie/user/:userId`, async (req, res) => {
  try {
    const userId = req.params.userId;
    const user = await getUser(userId);

    if (user) {
      res.status(200).send(user);
    } else {
      res.status(404).send({ error: "User not found" });
    }
  } catch (error) {
    res.status(500).send({ error: "Internal Server Error" });
  }
});

//Create user
app.post(`/chillmovie/user/create`, async (req, res) => {
  const { username, password, email } = req.body;
  const create = await createUser(username, password, email);
  res.status(201).send(create);
});

//Update user
app.post(`/chillmovie/user/update/:userId`, async (req, res) => {
  try {
    const { username, password, email } = req.body;
    const { userId } = req.params;

    // Validasi input: pastikan ada data untuk diperbarui
    if (!username && !password && !email) {
      return res.status(400).send({ error: "No data to update" });
    }

    const update = await updateUser(userId, { username, password, email });

    if (update.affectedRows > 0) {
      res.status(200).send({ message: "User updated successfully" });
    } else {
      res.status(404).send({ error: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "Internal Server Error" });
  }
});

//Delete user
app.delete(`/chillmovie/user/delete/:userId`, async (req, res) => {
  try {
    const userId = req.params.userId;

    if (!userId) {
      return res.status(400).send({ error: "User ID is required" });
    }

    const isDeleted = await deleteUser(userId);

    if (isDeleted) {
      res.status(200).send({ message: "Successfully deleted user" });
    } else {
      res.status(404).send({ error: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "Internal Server Error" });
  }
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Something broke!");
});

app.listen(8080, () => {
  console.log("Server is running on port 8080");
});
