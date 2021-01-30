const express = require('express');
const { getPlantedCredits, getCreditLeaderboard, addImage } = require('../../controllers/core/credit');

const router = express.Router();

// @ route:     GET /api/credit/leaderboard/
// @ desc:      Returns the leaderboard i.e. username, credits
// @ access:    public
router.get("/", getCreditLeaderboard);

// @ route:     GET /api/credit/:planted_id/
// @ desc:      Gets a credit details for a particular planted plant given a planted_id
// @ access:    logged-in user
router.get("/:planted_id/", getPlantedCredits);


// @ route:     POST /api/credit/:planted_id/
// @ desc:      posts an image of a plant and records the watering time(s) also issues regarding credits
// @ access:    logged-in user
router.post('/', addImage);

module.exports = router;