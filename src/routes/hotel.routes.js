const express = require("express");
const router = express.Router();
const hotelController = require("../controllers/hotel.controller");

router.get("/:location", hotelController.getHotels);
router.post("/", hotelController.addHotel);

module.exports = router;