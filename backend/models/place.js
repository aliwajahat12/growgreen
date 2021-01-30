const mongoose = require('mongoose');

const placeSchema = new mongoose.Schema({
    ownerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    placeName: {
        type: String,
        required: true
    },
    placeImage: {
        type: String,
        default: "https://images.unsplash.com/photo-1503453363464-743ee9ce1584?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8bGFuZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80"
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