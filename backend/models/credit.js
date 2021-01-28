const mongoose = require('mongoose');

const creditsSchema = new mongoose.Schema({
    plantedId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'planted',
        required: true
    },
    credits: Number,
    reason: {
        type: String,
        default: "Routine Watering",
    },
    date: {
        type: Date,
        default: Date.now
    },
    image: {
        type: String,
        required: true
    }
});

module.exports = mongoose.model('credit', creditsSchema);