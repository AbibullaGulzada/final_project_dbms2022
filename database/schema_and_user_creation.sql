CREATE USER BOSS IDENTIFIED BY bosspassesbook;
/
--password for BOSS is bosspassesbook.

SELECT * FROM dba_users WHERE username = 'BOSS';
--this one for checking the info about BOSS user
/

GRANT ALL PRIVILEGES TO BOSS;
/

--run this script in SYSTEM for creating a new user and granting access to it.
