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
        type: String,
        default: ""
    },
    country: {
        type: String,
        default: ""
    },
    state: {
        type: String,
        default: ""
    },
    address: {
        type: String,
        default: ""
    },
    dob: {
        type: Date,
        default: Date.parse("1-Jan-1970")
    },
    avatar: {
        type: String,
        default: "https://cdn2.iconfinder.com/data/icons/4web-3/139/header-account-image-line-512.png"
    }
});

module.exports = mongoose.model('user', userSchema);