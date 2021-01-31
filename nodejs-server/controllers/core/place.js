const mongoose = require("mongoose");

const PlaceModel = require("../../models/place");

module.exports = {
  addPlace: async (req, res) => {
    try {
      const { ownerId, isPublic, long, lat, placeName, placeImage } = req.body;
      if (await PlaceModel.findOne({ lat: lat, long: long })) {
        throw "exists";
      } else {
        const newPlace = new PlaceModel({
          ownerId: mongoose.Types.ObjectId(ownerId),
          isPublic: isPublic,
          long: long,
          lat: lat,
          placeName,
          placeImage,
        });
        await newPlace.save();
        console.log(newPlace);
        res.json({ status: "success", place_id: newPlace._id });
      }
    } catch (err) {
      if (err === "exists") {
        console.error("Error: Place already exists");
        res.json({ status: "fail", reason: "place already exists" });
      }
      console.error("Error: " + err.message);
      res.json({ status: "fail", reason: "error", error: err.message });
    }
  },
  getUserPlaces: async (req, res) => {
    try {
      const { user_id } = req.params;
      const place = await PlaceModel.find({
        $or: [
          { ownerId: mongoose.Types.ObjectId(user_id) },
          { isPublic: true },
        ],
      });
      res.json({ place });
    } catch (err) {
      console.log("Error: ", err.message);
      res.json({ status: "fail", reason: "error", error: err.message });
    }
  },
};
