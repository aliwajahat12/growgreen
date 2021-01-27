const mongoose = require('mongoose');

const placeSchema = new mongoose.Schema({
    ownerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    isPublic: {
        type: Boolean,
        default: true
    },
    coordX: Number,
    cooedY: Number
})

module.exports = mongoose.model('place', placeSchema)