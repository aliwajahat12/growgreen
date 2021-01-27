const bcrypt = require('bcrypt');

const UserModel = require('../../models/user');
const PlantedModel = require('../../models/planted');

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
    signinUser: (req, res) => {

    },
    getUserDetails: (req, res) => {

    },
    getUserCredits: async (req, res) => {
        try {
            
        } catch (error) {
            
        }
    },
    updateUserDetails: (req, res) => {

    }
}