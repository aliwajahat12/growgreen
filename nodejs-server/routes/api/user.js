const express = require('express');
const { signupUser, signinUser, getUserDetails, getUserCredits, updateUserDetails } = require('../../controllers/core/user');

const router = express.Router();

// @ route:     POST /api/user/signup/
// @ desc:      given user email and password, registers a user
// @ access:    public
router.post("/signup/", signupUser);

// @ route:     POST /api/user/signin/
// @ desc:      Sign in an already registered user 
// @ access:    public
router.post("/signin/", signinUser);

// @ route:     GET /api/user/:user_id/
// @ desc:      fetches an user details
// @ access:    public
router.get('/:user_id/', getUserDetails);

// @ route:     GET /api/user/:user_id/get_credits
// @ desc:      fetches an user credits
// @ access:    public
router.get('/:user_id/credits', getUserCredits);

// @ route:     PUT /api/user/:user_id/
// @ desc:      Updates an user details in the database
// @ access:    An user can update his/her own details
router.put('/:user_id/', updateUserDetails);

module.exports = router;