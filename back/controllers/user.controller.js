require('../config/config')
const oracledb = require('oracledb');
const bcrypt = require('bcryptjs');


oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
connectObj = { user: process.env.user, password: process.env.password, connectString: process.env.CONNECT_STRING }


module.exports.register = async(req, res, next) => {
    var connection = await oracledb.getConnection(connectObj);
    let password = req.body.password;
    bcrypt.genSalt(10, (err, salt) => {
        bcrypt.hash(password, salt, (err, hash) => {
            Hash = hash;

            connection.execute(
                `INSERT INTO Userss
                        (user_id, nickname, pass, phone_number, pass_salt)
                        VALUES
                        (0, :name, :pass, :num, :salt)
                        `, { name: req.body.name, pass: hash, num: req.body.phone, salt: salt }, { autoCommit: true }, (err, result) => {
                    if (err) {

                        console.log(err)
                        res.status(400).json(err);
                    }
                    res.status(200).json(result);
                    console.log(result);
                }
            );

        });
    });
}


module.exports.authenticate = async(req, res, next) => {
    var connection = await oracledb.getConnection(connectObj);
    console.log('sdfsd')
    connection.execute(
        `SELECT *  FROM Userss
                    WHERE nickname = : nickname
                    `, { nickname: req.body.name }, (err, result) => {
            if (err) {
                return res.status(500).json(err);
            } else if (result.rows.length < 1) {
                return res.status(404).json(err)
            } else if (result.rows.length > 0) {
                console.log(bcrypt.compareSync(req.body.password, result.rows[0].PASS))
                if (bcrypt.compareSync(req.body.password, result.rows[0].PASS)) {
                    return res.status(200).json({
                        user: result.rows[0],
                    })
                } else {
                    console.log("kavo5")
                    return res.status(403).json(err);
                }
            }
        }
    );
}