const express = require('express');
const {detectPlant, isAreaPlantable, addPlant} = require('../../controllers/core/plant');

const  router = express.Router();

// @ route:     POST /api/plant/detect_plant/
// @ desc:      returns a url to detected plant image.
// @ access:    logged in user
router.post("/detect_plant", detectPlant);

// @ route:     POST /api/plant/is_plantable/
// @ desc:      returns a url to detected plant image.
// @ access:    logged in user
router.post("/is_plantable/", isAreaPlantable);

// @ route:     POST /api/plant/
// @ desc:      Add a new plant
// @ access:    admin
router.post("/", addPlant);

module.exports = router;