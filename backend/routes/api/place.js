const express = require('express');
const {addPlace, getPlace} = require('../../controllers/core/place');

const  router = express.Router();

// @ route:     POST /api/place/
// @ desc:      add a new place
// @ access:    logged in user
router.post('/', addPlace);

// @ route:     GET /api/place/:place_id
// @ desc:      Get a place details
// @ access:    public
router.get('/:place_id/', getPlace);

module.exports = router;