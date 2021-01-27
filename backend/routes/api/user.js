const express = require('express');
const { signupUser, signinUser, getUserDetails, getUserCredits, updateUserDetails } = require('../../controllers/core/user');

const router = express.Router();

router.post("/signup/", signupUser);
router.post("/signin/", signinUser);
router.get('/:user_id/', getUserDetails);
router.get('/:user_id/get_credits', getUserCredits);
router.put('/:user_id/', updateUserDetails);

module.exports = router;