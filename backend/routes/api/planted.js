const express = require('express');
const {getPlantedDetails, getPlantedLeaderboard} = require('../../controllers/core/planted');

const  router = express.Router();

router.get("/:user_id/", getPlantedDetails);
//type = 'weekly' or 'overall'
router.get("/leaderboard/:type", getPlantedLeaderboard);

module.exports = router;    