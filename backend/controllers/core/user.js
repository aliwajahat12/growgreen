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
                await newUser.save();
                res.json({ 'status': 'success' , "user_id": newUser._id});
            }
        } catch (err) {
            console.error(err);
            if (err === 'exists') {
                res.json({ 'status': 'fail', 'reason': 'user already exists' });
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
                    res.json({ "status": "success", 'user_id': user._id });
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
            const user = await UserModel.findById(user_id, '_id name email city country state address dob avatar');
            if (user) res.json({user});
            else res.json({ 'status': 'failed', 'reason': 'invalid' });
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message });
        }
    },
    getUserCredits: async (req, res) => {
        try {
            const { user_id } = req.params;
            const user = await UserModel.findById(user_id, '_id');
            if (user) {
                const plantedPlants = await PlantedModel.find({ 'userId': mongoose.Types.ObjectId(user_id) });
                const credits = await CreditModel.find({ 'plantedId': plantedPlants._id });
                let userCredits = 0;
                for (credit in credits) {
                    userCredits += credit.credits;
                }
                res.json({ 'userCredits': userCredits });
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
            const user = await UserModel.findById(user_id, '_id name email city country state address dob avatar');
            user.name = name;
            user.city = city;
            user.country = country;
            user.state = state;
            user.address = address;
            user.dob = Date.parse(dob);
            await user.save();
            res.json({user});
        } catch (err) {
            console.log("Error occurred: " + err.message);
            res.json({ 'status': 'failed', 'reason': 'error', 'error': err.message });
        }
    }
}