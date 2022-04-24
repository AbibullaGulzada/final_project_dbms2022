require('./config/config')
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const passport = require('passport');

const rtsIndex = require('./routes/index.router')


app.use(bodyParser.json());
app.use(cors());
app.use(passport.initialize())
app.use('/api', rtsIndex);

console.log('dfsd')
app.listen(process.env.PORT, () => {
    console.log("server listening:" + process.env.PORT)
})


'/api/register'