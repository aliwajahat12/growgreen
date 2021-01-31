const mongoose = require('mongoose');
const CreditModel = require('../../models/credit');
const PlantedModel = require('../../models/planted');
const UserModel = require('../../models/user');

module.exports = {
    getPlantedCredits: async (req, res) => {

    },
    addImage: async (req, res) => {

    },
    getCreditLeaderboard: async (req, res) => {
        try {
            const overallLeaderboard = await CreditModel
                .aggregate()
                .lookup({
                    from: PlantedModel.collection.name,
                    localField: 'plantedId',
                    foreignField: '_id',
                    as: 'plantedData'
                })
                .lookup({
                    from: UserModel.collection.name,
                    localField: 'plantedData.userId',
                    foreignField: "_id",
                    as: 'userData'
                })
                .unwind({
                    path: "$userData",
                    preserveNullAndEmptyArrays: true
                })
                .group({
                    _id: "$userData._id",
                    totalCredits: { $sum: "$credits" }
                })
                .lookup({
                    from: UserModel.collection.name,
                    localField: '_id',
                    foreignField: "_id",
                    as: 'userData'
                })
                .unwind({
                    path: "$userData",
                    preserveNullAndEmptyArrays: true
                })
                .project({
                    "userData": { "email": 0 }
                })
                .project({
                    "userData": { "passwd": 0 }
                })
                .project({
                    "userData": { "__v": 0 }
                })
                .sort("-totalCredits");
            const datePriorWeek = new Date();
            datePriorWeek.setDate(datePriorWeek.getDate() - 7);
            
            const weeklyLeaderboard = await CreditModel
                .aggregate()
                .match({
                    "date": { "$gte": datePriorWeek}
                })
                .lookup({
                    from: PlantedModel.collection.name,
                    localField: 'plantedId',
                    foreignField: '_id',
                    as: 'plantedData'
                })
                .lookup({
                    from: UserModel.collection.name,
                    localField: 'plantedData.userId',
                    foreignField: "_id",
                    as: 'userData'
                })
                .unwind({
                    path: "$userData",
                    preserveNullAndEmptyArrays: true
                })
                .group({
                    _id: "$userData._id",
                    totalCredits: { $sum: "$credits" }
                })
                .lookup({
                    from: UserModel.collection.name,
                    localField: '_id',
                    foreignField: "_id",
                    as: 'userData'
                })
                .unwind({
                    path: "$userData",
                    preserveNullAndEmptyArrays: true
                })
                .project({
                    "userData": { "email": 0 }
                })
                .project({
                    "userData": { "passwd": 0 }
                })
                .project({
                    "userData": { "__v": 0 }
                })
                .sort("-totalCredits");
            console.log(weeklyLeaderboard);
            res.json({ overallLeaderboard, weeklyLeaderboard });
        } catch (err) {
            console.log(err.message);
            res.json({ 'status': 'fail' });
        }

    }
}