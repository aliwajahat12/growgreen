const express = require('express');
const userModel = require('../../models/user');
const plantedModel = require('../../models/planted');

const  router = express.Router();

router.post('/', (req, res) => {
    console.log(userModel);
})

router.get('/', (req, res) => {
    console.log(userModel);
    console.log(plantedModel);
    res.json({"hello": "hello"});
})

module.exports = router;