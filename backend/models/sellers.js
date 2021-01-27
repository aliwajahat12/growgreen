const mongoose = require('mongoose');

const sellerSchema = new mongoose.Schema({
    name: {
        type: String
    },
    address: {
        type: String,
        required: true
    },
    city: {
        type: String,
        required: true
    },
    country: {
        type: String,
        required: true
    },
    state: {
        type: String
    },
    availablePlants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'plant' }]
})

module.exports = mongoose.model('seller', sellerSchema);