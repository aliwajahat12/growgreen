const express = require('express');
const {addPlace, getUserPlaces} = require('../../controllers/core/place');

const  router = express.Router();

// @ route:     POST /api/place/
// @ desc:      add a new place
// @ access:    logged in user
router.post('/', addPlace);

// @ route:     GET /api/place/:user_id/
// @ desc:      get place details
// @ access:    user can get his/her own private places and all public places.
router.get('/:user_id/', getUserPlaces);

module.exports = router;