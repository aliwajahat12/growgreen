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
    lat:{
        type: Number,
        required: true
    },
    long:{
        type: Number,
        required: true
    }
})

module.exports = mongoose.model('place', placeSchema)