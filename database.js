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

//Register user
export async function registerUser(fullname, username, password, email, token) {
  const hashedPassword = password ? await bcrypt.hash(password, 10) : null;
  const [result] = await pool.query(
    `INSERT INTO User (fullname, username, password, email, token) VALUES (?, ?, ?, ?, ?)`,
    [fullname, username, hashedPassword, email, token]
  );
  const id = result.insertId;
  return getUser(id);
}

//Login user
export async function loginUser(email, password) {
  const [rows] = await pool.query(
    "SELECT user_id, username, password FROM User WHERE email = ?",
    [email]
  );
  if (rows.length === 0) {
    return null;
  }

  const user = rows[0];
  const passwordMatch = await bcrypt.compare(password, user.password);
  if (!passwordMatch) {
    return null;
  }
  return { user_id: user.user_id, username: user.username };
}

//Update user
export async function updateUser(
  userId,
  { fullname, username, password, email }
) {
  const hashedPassword = password ? await bcrypt.hash(password, 10) : null;

  const query = `
    UPDATE User
    SET
      fullname = COALESCE(?, fullname),
      username = COALESCE(?, username),
      email = COALESCE(?, email),
      password = COALESCE(?, password)
    WHERE user_id = ?;
  `;

  const [result] = await pool.query(query, [
    fullname,
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

//select all Movies
export async function getMovie({ filter, sort, search }) {
  let baseQuery = "SELECT * FROM Movie";
  const queryParams = [];
  const conditions = [];

  if (filter) {
    conditions.push("genre_id = ?");
    queryParams.push(filter);
  }

  if (search) {
    conditions.push("title LIKE ?");
    queryParams.push(`%${search}%`);
  }

  if (conditions.length > 0) {
    baseQuery += " WHERE " + conditions.join(" AND ");
  }

  if (sort) {
    const validSortColumns = ["title", "release_date"];
    const validSortDirection = ["asc", "desc"];
    const sortParts = sort.split("_");
    const column = sortParts.slice(0, -1).join("_");
    const direction = sortParts[sortParts.length - 1];
    if (validSortColumns.includes(column)) {
      if (validSortDirection.includes(direction)) {
        baseQuery += ` ORDER BY ${column} ${direction.toUpperCase()}`;
      } else {
        baseQuery += ` ORDER BY ${column} ASC`;
      }
    } else {
      throw new Error("Invalid sort parameter");
    }
  }
  const [rows] = await pool.query(baseQuery, queryParams);
  return rows;
}

/********/

//Get Users**//
// const result = await getUsers();
// console.log(result);

//Register user**///
// const result = await registerUser("Rahmat", "123cdef", "rahmat@dummyemail.co.id");
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
