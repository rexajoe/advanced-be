import express from "express";
import {
  getUsers,
  getUser,
  updateUser,
  deleteUser,
  registerUser,
  loginUser,
  getMovie,
} from "./database.js";
import { authenticateToken } from "./middleware/authenticateToken.js";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";
import { v4 as uuidv4 } from "uuid";
import { upload } from "./uploadConfig.js";

const app = express();
app.use(express.json());
app.use("/uploads", express.static("uploads"));

const SECRET_KEY = process.env.SECRET_KEY;

const transporter = nodemailer.createTransport({
  host: "smtp.ethereal.email",
  port: 587,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

async function sendVerificationEmail(email, token) {
  const url = `http://localhost:8080/verifikasi-email?token=${token}`;
  const mailOptions = {
    from: process.env.EMAIL_USER,
    to: email,
    subject: "Verifikasi Email",
    text: `Klik link berikut untuk memverifikasi email Anda: ${url}`,
  };
  await transporter.sendMail(mailOptions);
}

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

//Register user
app.post(`/chillmovie/user/register`, async (req, res) => {
  const { fullname, username, password, email } = req.body;
  const token = uuidv4();
  try {
    const create = await registerUser(
      fullname,
      username,
      password,
      email,
      token
    );
    await sendVerificationEmail(email, token);
    res.status(201).send({
      message: "User created successfully. Check your email for verification",
    });
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "Failed to register user" });
  }
});

//Login user
app.post(`/chillmovie/user/login`, async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await loginUser(email, password);
    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    const token = jwt.sign(
      {
        user_id: user.user_id,
        username: user.username,
      },
      SECRET_KEY,
      { expiresIn: "1h" }
    );
    res.status(200).json({ message: "Login sukses", token });
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
});

//Update user
app.post(`/chillmovie/user/update/:userId`, async (req, res) => {
  try {
    const { fullname, username, password, email } = req.body;
    const { userId } = req.params;

    // Validasi input: pastikan ada data untuk diperbarui
    if (!fullname && !username && !password && !email) {
      return res.status(400).send({ error: "No data to update" });
    }

    const update = await updateUser(userId, {
      fullname,
      username,
      password,
      email,
    });

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

//Get all Movie
app.get("/chillmovie/movie", authenticateToken, async (req, res) => {
  const { filter, sort, search } = req.query;
  try {
    const movie = await getMovie({ filter, sort, search });
    res
      .status(200)
      .json({ message: "This is movie page", user: req.user, movie: movie });
  } catch (error) {
    res.status(500).json({ error: "Failed to retrieve movies" });
  }
});

//Verifikasi Email
app.get("/chillmovie/verifikasi-email", async (req, res) => {
  const { token } = req.query;
  if (!token) {
    return res.status(400).send({ error: "Token is required" });
  }
  try {
    const [rows] = await poll.query("SELECT * FROM User WHERE token = ?", [
      token,
    ]);
    if (rows.length === 0) {
      return res.status(400).send({ error: "Invalid Verification Token" });
    }
    const user = rows[0];
    if (user.is_verified) {
      return res.status(400).send({ message: "Email already verified" });
    }
    await pool.query(
      "UPDATE User SET is_verified = TRUE, token = NULL WHERE user_id = ?",
      [user.user_id]
    );
    res.status(200).send({ message: "Email Verified Successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "Failed to verify email" });
  }
});

//Upload image
app.post(
  "/chillmovie/upload",
  authenticateToken,
  upload.single("file"),
  (req, res) => {
    try {
      const file = req.file;
      if (!file) {
        return res.status(400).json({ error: "Please upload an image file" });
      }
      res.status(200).json({
        message: "Image uploaded successfully",
        filePath: `/uploads/${file.filename}`,
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);
