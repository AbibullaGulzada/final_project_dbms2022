-- This is how books_pck.get_books_by_page_num() should works in pl_sql
-- DECLARE
--     mycur SYS_REFCURSOR;
--     v_rec books_pck.books_rec_type;
-- BEGIN
--     books_pck.get_books_by_page_num(1, mycur);
--     LOOP
--       FETCH mycur INTO v_rec;
--       EXIT WHEN mycur%NOTFOUND;
--       DBMS_OUTPUT.put_line(v_rec.p_title || ' ' || v_rec.p_price);
--     END LOOP;
-- END;
-- /

create or replace PACKAGE books_pck AS
    PROCEDURE book_insert(
        p_amazond_index IN book.amazon_index%TYPE,
        p_image_url IN book.image_url%TYPE,
        p_title IN book.title%TYPE,
        p_author IN book.author%TYPE,
        p_price IN book.price%TYPE,
        p_category_id IN book.category_id%TYPE,
        p_date IN VARCHAR2
        );

    PROCEDURE category_insert(
        p_category_name IN categories.category_name%TYPE
    );

    TYPE books_rec_type IS RECORD (
            p_amazond_index book.amazon_index%TYPE,
            p_image_url book.image_url%TYPE,
            p_title book.title%TYPE,
            p_author book.author%TYPE,
            p_price book.price%TYPE,
            p_category_id book.category_id%TYPE,
            p_date book.written_date%TYPE,
            p_category_name categories.category_name%TYPE
        );

    TYPE books_cur IS REF CURSOR; --weak ref cursor that return any num of vars.

    TYPE cats_list IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

    PROCEDURE get_books_by_page_num(
        p_page_num IN NUMBER,
        p_books_cur OUT SYS_REFCURSOR
        );
END books_pck;
/

create or replace PACKAGE BODY books_pck AS
    PROCEDURE book_insert(
        p_amazond_index IN book.amazon_index%TYPE,
        p_image_url IN book.image_url%TYPE,
        p_title IN book.title%TYPE,
        p_author IN book.author%TYPE,
        p_price IN book.price%TYPE,
        p_category_id IN book.category_id%TYPE,
        p_date IN VARCHAR2
    )
    AS
    BEGIN
        INSERT INTO book(
            amazon_index,
            image_url,
            title,
            author,
            price,
            category_id,
            written_date
        )
        VALUES(
            p_amazond_index,
            p_image_url,
            p_title,
            p_author,
            p_price,
            p_category_id,
            to_date(p_date, 'MM/DD/YYYY')
        );
        COMMIT;
    END book_insert;

    PROCEDURE category_insert(
        p_category_name IN categories.category_name%TYPE
    )
    AS
        e_category_already_exists EXCEPTION;
        PRAGMA exception_init( e_category_already_exists, -20001 );
        c_list books_pck.cats_list;
        cnt NUMBER;
        i NUMBER := 1;
        j NUMBER := 1;
        v_check BOOLEAN;
    BEGIN
        SELECT COUNT(*)
            INTO cnt
            FROM categories;

        WHILE i <= cnt
        LOOP
            SELECT LOWER(category_name)
                INTO c_list(i)
                FROM categories WHERE category_id = i;
            i := i + 1;
        END LOOP;

        v_check := FALSE;

        WHILE j <= cnt LOOP
            --dbms_output.put_line(c_list(j));
            IF LOWER(c_list(j)) = LOWER(p_category_name) THEN v_check := TRUE;
            END IF;
            j := j + 1;
        END LOOP;

        IF v_check THEN
            DBMS_OUTPUT.PUT_LINE('this category already exists');
            RAISE e_category_already_exists;
        ELSE
            INSERT INTO categories(
                category_name
            )
            VALUES(
                p_category_name
            );
            COMMIT;
        END IF;
    END category_insert;

    PROCEDURE get_books_by_page_num(
        p_page_num IN NUMBER,
        p_books_cur OUT SYS_REFCURSOR
    )
    AS
        off_set NUMBER;
        v_dynamic_stmt VARCHAR2(1111);
    BEGIN
        v_dynamic_stmt :=
                    'SELECT b.amazon_index, b.image_url, b.title, b.author, b.price, b.category_id, b.written_date, c.category_name'
                    || CHR(10) || 'FROM Book b, Categories c'
                    || CHR(10) || 'WHERE b.category_id = c.category_id'
                    || CHR(10) || 'ORDER BY b.title'
                    || CHR(10) || 'OFFSET :p_page_num ROWS FETCH FIRST 20 ROWS ONLY'; ---- Dynamic sql with placeholder :off_set
        OPEN p_books_cur FOR v_dynamic_stmt USING p_page_num; --open cursor for dynamic sql
        --You need to fetch rows outside of this procedure. when calling proc. Then close the cursor.
    END get_books_by_page_num;
END books_pck;
/


--3 procedures, 1 record, 1 cursor, 1 composite dtype, 1 dynamic sql, 