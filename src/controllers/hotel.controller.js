const db = require("../config/db");

// ✅ GET hotels by location
exports.getHotels = (req, res) => {
  const location = req.params.location;

  const query = `
    SELECT * FROM hotels
    WHERE location LIKE ?
  `;

  db.query(query, [`%${location}%`], (err, results) => {
    if (err) return res.status(500).json(err);

    const data = results.map((hotel) => ({
      ...hotel,
      features: JSON.parse(hotel.features || "[]"),
    }));

    res.json(data);
  });
};

// ✅ ADD hotel (Admin)
exports.addHotel = (req, res) => {
  const {
    name,
    location,
    price,
    old_price,
    rating,
    reviews,
    image,
    features,
  } = req.body;

  const query = `
    INSERT INTO hotels
    (name, location, price, old_price, rating, reviews, image, features)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    query,
    [
      name,
      location,
      price,
      old_price,
      rating,
      reviews,
      image,
      JSON.stringify(features),
    ],
    (err, result) => {
      if (err) return res.status(500).json(err);

      res.json({ message: "Hotel added successfully" });
    }
  );
};