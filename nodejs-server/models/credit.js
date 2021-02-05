const mongoose = require('mongoose');

const creditSchema = new mongoose.Schema({
    plantedId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'planted',
        default: null
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    isRelatedToPlanted: {
        type: Boolean,
        default: true
    },
    credits: Number,
    reason: {
        type: String,
        default: "Routine Watering",
    },
    approvalStage: {
        type: Number,
        default: 0
        // 0 for pending
        // 1 for approved
        // -1 for rejected
    },
    date: {
        type: Date,
        default: Date.now
    },
    image: {
        type: String,
        default: ""
    }
});

module.exports = mongoose.model('credit', creditSchema);