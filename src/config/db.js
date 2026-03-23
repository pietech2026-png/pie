const mysql = require("mysql2");

const db = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "YOUR_PASSWORD",
  database: "hotel_app",
  waitForConnections: true,
  connectionLimit: 10,
});

module.exports = db;