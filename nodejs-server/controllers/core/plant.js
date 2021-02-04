const PlantModel = require("../../models/plant");

module.exports = {
  detectPlant: async (req, res) => {},
  isAreaPlantable: async (req, res) => {},
  addPlant: async (req, res) => {
    try {
      const {
        name,
        picture,
        wateringInterval,
        wateringAmount,
        soilPh,
        plantingCredits,
        wateringCredits,
        fertilizer,
        fertilizationInterval,
        fertilizationAmount,
      } = req.body;
      const newPlant = new PlantModel({
        name: name,
        picture: picture,
        wateringInterval: wateringInterval,
        wateringAmount: wateringAmount,
        fertilizer: fertilizer,
        fertilizationInterval: fertilizationInterval,
        fertilizationAmount: fertilizationAmount,
        soilPh: soilPh,
        plantingCredits: plantingCredits,
        wateringCredits: wateringCredits,
      });

      await newPlant.save();
      res.json({ status: "success", id: newPlant._id, newPlant});
    } catch (err) {
      console.log("Error: " + err.message);
      res.json({ status: "fail", error: err });
    }
  },
  getPlants: async (req, res) => {
    try {
      const plants = await PlantModel.find({});
      res.json({ status: "succeess", plants });
    } catch (err) {
      res.json({ status: "fail", reason: "error", error: err.message });
    }
  },
};
