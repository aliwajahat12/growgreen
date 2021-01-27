const mongoose = require('mongoose');

const plantSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true        
    },
    picture: {
        type: String,
        default: "insert some plant image link here"
    },
    wateringInterval: Number,
    wateringAmount: Number,
    soilPH: Number,
    plantingCredits: Number,
    wateringCredits: Number
})

module.exports = mongoose.model('plant', plantSchema);