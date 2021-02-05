const mongoose = require("mongoose");

const UserModel = require("../../models/user");
const PlantedModel = require("../../models/planted");
const CreditModel = require("../../models/credit");
const PlantModel = require("../../models/plant");
const PlaceModel = require("../../models/place");

module.exports = {
  getPlanted: async (req, res) => {
    try {
      const { user_id } = req.params;
      const plants_by_user = await PlantedModel.find({
        userId: mongoose.Types.ObjectId(user_id),
      });
      res.json({ planted_details: plants_by_user });
    } catch (err) {
      console.error("Error: " + err.message);
      res.json({ status: "failed", reason: "error", error: err.message });
    }
  },
  newPlant: async (req, res) => {
    try {
      const { user_id } = req.params;
      const { plantId, media, lat, long, nickname } = req.body;
      let placeId = null;
      const place = await PlaceModel.find({ lat: lat, long: long });
      if (place.length === 0) {
        const newPlace = new PlaceModel({
          ownerId: mongoose.Types.ObjectId(user_id),
          placeName: `${nickname}'s default place`,
          isPublic: false,
          lat: lat,
          long: long,
        });
        await newPlace.save();
        placeId = newPlace._id;
      } else {
        placeId = place[0]._id;
      }
      const newPlant = new PlantedModel({
        userId: mongoose.Types.ObjectId(user_id),
        plantId: mongoose.Types.ObjectId(plantId),
        placeId: mongoose.Types.ObjectId(placeId),
        nickname: nickname,
        image: media,
      });
      await newPlant.save();
      const plant = await PlantModel.findById(plantId);
      const newCredit = new CreditModel({
        userId: user_id,
        plantedId: newPlant._id,
        credits: plant.plantingCredits,
        reason: "New plant planted.",
        image: media,
        approvalStage: 1
      });
      await newCredit.save();
      res.json({ status: "success", newPlant });
    } catch (err) {
      console.log(err.message);
      res.json({ status: "fail", reason: "error", error: err.message });
    }
  },
};
