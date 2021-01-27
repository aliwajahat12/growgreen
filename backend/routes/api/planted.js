const express = require('express');
const {getPlantedDetails, getPlantedLeaderboard} = require('../../controllers/core/planted');

const  router = express.Router();

// @ route: /api/planted/:user_id/
// @ desc: Returns an array of planted plants by an user
// @ access: a user can access his/her own plants
router.get("/:user_id/", getPlantedDetails);

// @ route: /api/planted/leaderboart/:type where type='weekly'or'overall'
// @ desc: Returns the leaderboard i.e. username, credits
// @ access: public
router.get("/leaderboard/:type", getPlantedLeaderboard);

module.exports = router;