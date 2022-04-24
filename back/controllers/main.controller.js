require('../config/config')
const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
connectObj = { user: process.env.user, password: process.env.password, connectString: process.env.CONNECT_STRING }