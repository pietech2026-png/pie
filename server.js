const express = require("express");
const mongoose = require("mongoose");

const app = express();

mongoose.connect("mongodb+srv://piedev1111_db_user:pie1234@clusterpie.q0dn72b.mongodb.net/piedb?retryWrites=true&w=majority")  .then(() => console.log("✅ MongoDB Connected"))
  .catch(err => console.log("❌ Error:", err));

app.get("/", (req, res) => {
  res.send("API running...");
});

app.listen(3000, () => {
  console.log("🚀 Server running on port 3000");
});