import mysql from "mysql2";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
dotenv.config();

const pool = mysql
  .createPool({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
  })
  .promise();

//select all from User
export async function getUsers() {
  const [rows] = await pool.query("SELECT * FROM User");
  return rows;
}

//select User by user_id
export async function getUser(id) {
  const [rows] = await pool.query(`SELECT * FROM User WHERE user_id = ?`, [id]);
  return rows[0];
}

//create user
export async function createUser(username, password, email) {
  const hashedPassword = password ? await bcrypt.hash(password, 10) : null;
  const [result] = await pool.query(
    `INSERT INTO User (username, password, email) VALUES (?, ?, ?)`,
    [username, hashedPassword, email]
  );
  const id = result.insertId;
  return getUser(id);
}

//Update user

export async function updateUser(userId, { username, password, email }) {
  const hashedPassword = password ? await bcrypt.hash(password, 10) : null;

  const query = `
    UPDATE User
    SET
      username = COALESCE(?, username),
      email = COALESCE(?, email),
      password = COALESCE(?, password)
    WHERE user_id = ?;
  `;

  const [result] = await pool.query(query, [
    username,
    email,
    hashedPassword,
    userId,
  ]);
  return result;
}

//Delete user
export async function deleteUser(userId) {
  const [result] = await pool.query(`DELETE FROM User WHERE user_id = ?`, [
    userId,
  ]);
  return result;
}

/********/

//Get Users**//
// const result = await getUsers();
// console.log(result);

//Create user**///
// const result = await createUser("Rahmat", "123cdef", "rahmat@dummyemail.co.id");
// console.log(result);

//Update User**///
// Hanya memperbarui username
// await updateUser(
//   { usernameNew: "Setiawan", emailNew: null, passwordNew: null },
//   "RahmatBaru"
// );

// Memperbarui email dan password
// await updateUser(
//   {
//     usernameNew: null,
//     emailNew: "rahmat@example.com",
//     passwordNew: "newPassword123",
//   },
//   "Rahmat"
// );

// Memperbarui semuanya
// await updateUser(
//   {
//     usernameNew: "RahmatBaru",
//     emailNew: "rahmat@example.com",
//     passwordNew: "newPassword123",
//   },
//   "Rahmat"
// );

//Delete User**//
// const result = await deleteUser("Rahmat New");
// console.log(result);
