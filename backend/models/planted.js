const mongoose = require('mongoose');

const plantedSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    plantId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'plant',
        required: true
    },
    placeId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'place',
        required: true
    },
    images: [{
        type: String,
        required: true
    }],
    date: {
        type: Date,
        default: Date.now
    }
})

module.exports = mongoose.model('planted', plantedSchema);