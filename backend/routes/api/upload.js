const express = require('express');
const {handleUpload} = require("../../controllers/core/upload");

const router = express.Router();

// @ route:     POST /api/upload/:user_id/
// @ desc:      Uloads an image on behalf of a user and returns the image public URL.
// @ access:    logged-in user

router.post("/:user_id/", handleUpload);

module.exports = router;