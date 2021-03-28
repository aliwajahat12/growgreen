const express = require('express');
const { getPlanted, newPlant, getPlantedObject } = require('../../controllers/core/planted');

const router = express.Router();

// @ route:     GET /api/planted/userId/:user_id/
// @ desc:      Returns an array of planted plants by an user
// @ access:    a user can access his/her own plants
router.get("/userId/:user_id/", getPlanted);


// @ route:     GET /api/planted/plantId/:user_id/
// @ desc:      Returns an Object with PlantedId = PlantedId
// @ access:    a user can access his/her own plants
router.get("/plantId/:user_id/", getPlantedObject);

// @ route:     POST /api/planted
// @ desc:      Adds a new plant
// @ access:    logged in user can add his/her own plants
router.post('/:user_id/', newPlant);

module.exports = router;