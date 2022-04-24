CREATE OR REPLACE package baskets_pck AS
	PROCEDURE book_into_basket(
		p_user_id IN Basket.user_id%TYPE,
        p_amazond_index IN Basket.amazon_index%TYPE
    );

    PROCEDURE remove_from_basket(
    	p_user_id IN Basket.user_id%TYPE,
    	p_amazond_index IN Basket.amazon_index%TYPE
    );

    TYPE basket_rec IS RECORD(
    	p_amazond_index Basket.amazon_index%TYPE
    );

    PROCEDURE get_basket_books(
    	p_user_id IN Basket.user_id%TYPE,
    	p_basket_books_cur OUT SYS_REFCURSOR
    );
END baskets_pck;
/

create or replace PACKAGE BODY baskets_pck AS
	PROCEDURE book_into_basket(
		p_user_id IN Basket.user_id%TYPE,
        p_amazond_index IN Basket.amazon_index%TYPE
    )
    AS
    BEGIN
        INSERT INTO Basket(
        	user_id,
        	amazon_index
        )
        VALUES(
        	p_user_id,
            p_amazond_index
        );
        COMMIT;
    END book_into_basket;

    PROCEDURE remove_from_basket(
    	p_user_id IN Basket.user_id%TYPE,
    	p_amazond_index IN Basket.amazon_index%TYPE
    )
    AS
    BEGIN
    	DELETE
			FROM Basket
			WHERE user_id = p_user_id
			AND amazon_index = p_amazond_index;
    	COMMIT;
    END remove_from_basket;

    PROCEDURE get_basket_books(
    	p_user_id IN Basket.user_id%TYPE,
    	p_basket_books_cur OUT SYS_REFCURSOR
    )
    AS
    BEGIN
    	OPEN p_basket_books_cur FOR
        	SELECT amazon_index
        		FROM Basket
        		WHERE user_id = p_user_id;
    END get_basket_books;
END baskets_pck;
/

--3 procedures, 1 cursor, and dynamic sql usage(OPEN FOR), 1 record