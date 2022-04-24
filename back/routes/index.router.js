const { Router } = require('express');
const express = require('express');
const router = express.Router();
const ctrlUser = require('../controllers/user.controller');
const ctrlMain = require('../controllers/main.controller');

router.post('/register', ctrlUser.register);
router.post('/auth', ctrlUser.authenticate);

// router.get('', )
module.exports = router;