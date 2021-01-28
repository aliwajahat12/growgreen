const bcrypt = require('bcrypt');
const mongoose = require('mongoose');

const UserModel = require('../../models/user');
const PlantedModel = require('../../models/planted');
const CreditModel = require('../../models/credit');

require('dotenv').config();

module.exports = {
    signupUser: async (req, res) => {
        try {
            const { name, email, passwd } = req.body;
            if (await UserModel.findOne({ 'email': email })) {
                throw "exists";

            } else {
                console.log(process.env.BCRYPT_SALTS);
                const hash = await bcrypt.hash(passwd, await bcrypt.genSalt(Number(process.env.BCRYPT_SALTS)));
                const newUser = new UserModel({ 'name': name, 'email': email, 'passwd': hash });
                newUser.save();
                res.json({ 'status': 'success' });
            }
        } catch (err) {
            console.error(err);
            if (err === 'exists') {
                res.json({ 'status': 'fail', 'reason': 'user already exists' })
            }
            else {
                res.json({ 'status': 'fail', 'reason': err.message });
            }
        }

    },
    signinUser: async (req, res) => {
        try {
            const { email, passwd } = req.body;
            const user = await UserModel.findOne({ 'email': email });
            if (user) {
                const isValid = await bcrypt.compare(passwd, user.passwd);
                if (isValid) {
                    res.json({ "status": "success", 'id': user._id });
                } else {
                    res.json({ "status": "failed", "reason": 'invalid' });
                }
            } else {
                res.json({ "status": "failed", "reason": 'invalid' });
            }
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message })
        }
    },
    getUserDetails: async (req, res) => {
        try {
            const { user_id } = req.params;
            const user = await UserModel.findById(user_id);
            if (user) res.json(user);
            else res.json({ 'status': 'failed', 'reason': 'invalid' });
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message });
        }
    },
    getUserCredits: async (req, res) => {
        try {
            const { user_id } = req.params;
            if (user) {
                const plantedPlants = await PlantedModel.find({ 'userId': mongoose.Schema.Types.ObjectId(user_id) });
                const credits = await CreditModel.find({ 'plantedId': plantedPlants._id });
                let userCredits = 0;
                for (credit in credits) {
                    userCredits += credit.credits;
                }
                res.json({ 'userCredits': userCredits, 'creditDeatils': credits });
            } else {
                res.json({ 'status': 'failed', 'reason': 'invalid' });
            }
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message });
        }
    },
    updateUserDetails: async (req, res) => {
        try {
            const {name, city, country, state, address, dob} = req.body;
            const {user_id} = req.params;
            const user = UserModel.findById(user_id);
            user.name = name;
            user.city = city;
            user.country = country;
            user.state = state;
            user.address = address;
            user.dob = dob;
            user.save();
            res.json({user});
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message });
        }
    }
}