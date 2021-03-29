const mongoose = require("mongoose");
const CreditModel = require("../../models/credit");
const PlantedModel = require("../../models/planted");
const UserModel = require("../../models/user");

module.exports = {
  getPlantedCredits: async (req, res) => {
    try {
      const { planted_Id } = req.body;
      const foundPlantsCredits = CreditModel.find(
        { plantedId: mongoose.Types.ObjectId(planted_Id)}
      )
      res.json({
        status: "success", foundPlantsCredits
      })
    } catch (err) {
      console.log("Error in Getting Planted Credits: " + err.message);
      res.json({
        status: "fail",
        reason: "error",
        error: err.messsage,
      });
    }
  },
  addCredits: async (req, res) => {
    try {
      const {
        plantedId,
        userId,
        isRelatedToPlanted,
        credits,
        image,
        reason,
      } = req.body;
      const newCredit = new CreditModel({
        userId: mongoose.Types.ObjectId(userId),
        isRelatedToPlanted: isRelatedToPlanted,
        credits: credits,
        approvalStage: 0,
        image: image,
        reason: reason,
      });
      if (isRelatedToPlanted) {
        newCredit.plantedId = mongoose.Types.ObjectId(plantedId);
        const wateringCreditsPlant = await PlantedModel.findById(
          plantedId
        ).populate("plantId");
        console.log(wateringCreditsPlant);
        newCredit.credits = wateringCreditsPlant.plantId.wateringCredits;
        if (reason === null) {
          newCredit.reason = "Schedule watering";
        }
      }
      await newCredit.save();
      res.json({ status: "success", newCredit });
    } catch (err) {
      console.log("Error: " + err.message);
      res.json({
        status: "fail",
        reason: "error",
        error: err.messsage,
      });
    }
  },
  getCreditLeaderboard: async (req, res) => {
    try {
      const overallLeaderboard = await CreditModel.aggregate()
        .lookup({
          from: UserModel.collection.name,
          localField: "userId",
          foreignField: "_id",
          as: "userData",
        })
        .unwind({
          path: "$userData",
          preserveNullAndEmptyArrays: true,
        })
        .group({
          _id: "$userData._id",
          totalCredits: { $sum: "$credits" },
        })
        .lookup({
          from: UserModel.collection.name,
          localField: "_id",
          foreignField: "_id",
          as: "userData",
        })
        .unwind({
          path: "$userData",
          preserveNullAndEmptyArrays: true,
        })
        .project({
          userData: { email: 0 },
        })
        .project({
          userData: { passwd: 0 },
        })
        .project({
          userData: { __v: 0 },
        })
        .sort("-totalCredits");
      const datePriorWeek = new Date();
      datePriorWeek.setDate(datePriorWeek.getDate() - 7);

      const weeklyLeaderboard = await CreditModel.aggregate()
        .match({
          date: { $gte: datePriorWeek },
        })
        .lookup({
          from: UserModel.collection.name,
          localField: "userId",
          foreignField: "_id",
          as: "userData",
        })
        .unwind({
          path: "$userData",
          preserveNullAndEmptyArrays: true,
        })
        .group({
          _id: "$userData._id",
          totalCredits: { $sum: "$credits" },
        })
        .lookup({
          from: UserModel.collection.name,
          localField: "_id",
          foreignField: "_id",
          as: "userData",
        })
        .unwind({
          path: "$userData",
          preserveNullAndEmptyArrays: true,
        })
        .project({
          userData: { email: 0 },
        })
        .project({
          userData: { passwd: 0 },
        })
        .project({
          userData: { __v: 0 },
        })
        .sort("-totalCredits");
      console.log(weeklyLeaderboard);
      res.json({ overallLeaderboard, weeklyLeaderboard });
    } catch (err) {
      console.log(err.message);
      res.json({ status: "fail" });
    }
  },
};
