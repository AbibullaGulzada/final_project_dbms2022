CREATE OR REPLACE PROCEDURE reset_seq(
    p_seq_name in VARCHAR2
    )
    IS
        l_val NUMBER;
    BEGIN
        EXECUTE IMMEDIATE
        'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO l_val;

        EXECUTE IMMEDIATE
        'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY -' || l_val || 
                                                          ' MINVALUE 1';

        EXECUTE IMMEDIATE
        'SELECT ' || p_seq_name || '.NEXTVAL FROM DUAL' INTO l_val;

        EXECUTE IMMEDIATE
        'ALTER SEQUENCE ' || p_seq_name || ' INCREMENT BY 1 MINVALUE 1';
    END reset_seq;
/