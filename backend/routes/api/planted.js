const express = require('express');
const {getPlanted, getPlantedLeaderboard, newPlant} = require('../../controllers/core/planted');

const  router = express.Router();

// @ route:     GET /api/planted/:user_id/
// @ desc:      Returns an array of planted plants by an user
// @ access:    a user can access his/her own plants
router.get("/:user_id/", getPlanted);

// @ route:     GET /api/planted/leaderboard/:type where type='weekly'or'overall'
// @ desc:      Returns the leaderboard i.e. username, credits
// @ access:    public
router.get("/leaderboard/:type", getPlantedLeaderboard);

// @ route:     POST /api/planted
// @ desc:      Adds a new plant
// @ access:    logged in user can add his/her own plants
router.post('/:user_id', newPlant);

module.exports = router;