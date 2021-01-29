const mongoose = require('mongoose');

const PlaceModel = require('../../models/place');
const UserModel = require('../../models/user');

module.exports = {
    addPlace: async (req, res) => {
        try {
            const { ownerId, isPublic, long, lat } = req.body;
            if (await PlaceModel.findOne({ "lat": lat, "long": long })) {
                throw "exists";
            } else {
                const newPlace = new PlaceModel({ "ownerId": mongoose.Types.ObjectId(ownerId), "isPublic": isPublic, "long": long, "lat": lat });
                await newPlace.save();
                res.json({ "status": "success", "place_id": newPlace._id });
            }

        } catch (err) {
            if (err === 'exists') {
                console.error("Error: Place already exists");
                res.json({ 'status': 'fail', 'reason': 'place already exists' });
            }
            console.error("Error: " + err.message);
            res.json({ 'status': 'fail', 'reason': 'error', 'error': err.message });
        }
    },
    getPlace: async (req, res) => {
        try {
            const { place_id } = req.params;
            const place = await PlaceModel.findById(place_id);
            const owner = await UserModel.findById(place.ownerId, "name city country state");
            place.ownerId = null;
            res.json({place, "owner": owner});
        } catch (err) {
            console.log("Error: ", err.message);
            res.json({ "status": "fail", "reason": "error", "error": err.message });
        }
    }
}