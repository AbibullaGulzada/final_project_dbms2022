CREATE OR REPLACE package removing_pck AS
	procedure delete_user(
		p_nickname IN Userss.nickname%TYPE
		);
END removing_pck;
/

CREATE OR REPLACE PACKAGE BODY removing_pck AS
	PROCEDURE delete_user(
		p_nickname IN Userss.nickname%TYPE
	)
	IS
	BEGIN
		DELETE FROM Userss
		WHERE nickname = p_nickname;
		
		COMMIT;
	END delete_user;
END removing_pck;
/

--1 procedure