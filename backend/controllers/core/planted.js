const mongoose = require('mongoose');

const UserModel = require('../../models/user');
const PlantedModel = require('../../models/planted');
const CreditModel = require('../../models/credit');

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
    getPlantedLeaderboard: async (req, res) => {

    },
    newPlant: async (req, res) => {
        try {
            const {user_id} = req.params;
            const {plantId, placeId, location, images} = req.body;
        } catch (err) {
            
        }
    }
}