const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    passwd: {
        type: String,
        required: true
    },
    city: {
        type: String
    },
    country: {
        type: String
    },
    state: {
        type: String
    },
    address: {
        type: String
    },
    dob: {
        type: Date
    }
});

module.exports = mongoose.model('user', userSchema);