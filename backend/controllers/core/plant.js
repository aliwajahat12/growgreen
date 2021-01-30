const PlantModel = require('../../models/plant');

module.exports = {
    detectPlant: async (req, res) => {

    },
    isAreaPlantable: async (req, res) => {

    },
    addPlant: async (req, res) => {
        try {
            const { name, picture, wateringInterval, wateringAmount, soilPh, plantingCredits, wateringCredits } = req.body;
            const newPlant = new PlantModel({
                                        'name': name,
                                        'picture': picture,
                                        'wateringInterval': wateringInterval,
                                        'wateringAmount': wateringAmount,
                                        'soilPh': soilPh,
                                        'plantingCredits': plantingCredits,
                                        'wateringCredits': wateringCredits
                                    });
            
            await newPlant.save();
            res.json({'status': 'success', "id": newPlant._id});
        } catch (err) {
            console.log('Error: ' + err.message);
            res.json({'status': 'fail', 'error': err});
        }
    }
}