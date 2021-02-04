const mongoose = require('mongoose');

const UserModel = require('../../models/user');
const PlantedModel = require('../../models/planted');
const CreditModel = require('../../models/credit');
const PlantModel = require("../../models/plant");

module.exports = {
    getPlanted: async (req, res) => {
        try {
            const { user_id } = req.params;
            const plants_by_user = await PlantedModel.find({ 'userId': mongoose.Schema.Types.ObjectId(user_id) });
            res.json({'planted_details': plants_by_user});
        } catch (err) {
            console.error("Error: " + err.message);
            res.json({'status': 'failed', 'reason': 'error', 'error': err.message});
        }

    },
    newPlant: async (req, res) => {
        try {
            const {user_id} = req.params;
            const {plantId, placeId, imageURL} = req.body;
            const newPlant = new PlantedModel({"userId": user_id, plantId, placeId, image: imageURL})
            await newPlant.save();
            const plant = await PlantModel.findById(plantId);
            const newCredit = new CreditModel({"plantedId": newPlant._id, "credits": plant.plantingCredits, "reason": "New plant planted.", "picture": imageURL});
            await newCredit.save();
            // res.json({"status": })
        } catch (err) {
            console.log(err.message);
            res.json({"status": "fail", "reason": "error", "error": err.message});
        }
    }
}