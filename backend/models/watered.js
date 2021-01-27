const mongoose = require('mongoose');

const wateredSchema = new mongoose.Schema({
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
    }
});

module.exports = mongoose.model('watered', wateredSchema);