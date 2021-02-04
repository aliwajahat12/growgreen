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
    "fertilizer": String,
    "fertilizationInterval": Number, //Interval in days
    "fertilizationAmount": Number, //Amount in grams
    wateringInterval: Number,
    wateringAmount: Number,
    soilPh: Number,
    plantingCredits: Number,
    wateringCredits: Number
})

module.exports = mongoose.model('plant', plantSchema);