CREATE OR REPLACE package login_pck AS
    FUNCTION confirmation(
        p_nickname IN Userss.nickname%TYPE,
        p_password IN Userss.pass%TYPE
    ) RETURN BOOLEAN;

    TYPE user_rec IS RECORD (
        p_nickname Userss.nickname%TYPE,
        p_password Userss.pass%TYPE,
        p_phone_number Userss.phone_number%TYPE,
        p_pass_salt Userss.pass_salt%TYPE
    );

    PROCEDURE get_user(
        p_nickname IN Userss.nickname%TYPE,
        p_user_out OUT user_rec
    );
END login_pck;
/

CREATE OR REPLACE PACKAGE BODY login_pck AS
    FUNCTION confirmation(
        p_nickname IN Userss.nickname%TYPE,
        p_password IN Userss.pass%TYPE
    ) RETURN BOOLEAN
    IS
        is_true BOOLEAN := FALSE;
        v_pass Userss.pass%TYPE;
    BEGIN
        BEGIN
            SELECT pass INTO v_pass
                FROM Userss
                WHERE nickname = p_nickname;
        
            IF (p_password = v_pass) THEN is_true := TRUE;
            ELSE is_true := FALSE;
            END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RETURN FALSE;
        END;
        RETURN is_true;
    END confirmation;

    PROCEDURE get_user(
        p_nickname IN Userss.nickname%TYPE,
        p_user_out OUT user_rec
    )
    AS
    BEGIN
        SELECT nickname, pass, phone_number, pass_salt
            INTO p_user_out
            FROM Userss
            WHERE nickname = p_nickname;
    END get_user;
END login_pck;
/

-- 1 function, 1 record, 1 procedure, 1 exception.