import pandas as pd
from pandas import DataFrame, read_excel
import numpy as np
import cx_Oracle

book_df = pd.read_excel (r'D:\Users\Almas\Documents\GitHub\DB_PROJECT_SDU\data_parsing\final_data.xlsx')

date_converter = {
    'jan': '1',
    'feb': '2',
    'mar': '3',
    'apr': '4',
    'may': '5',
    'jun': '6',
    'jul': '7',
    'aug': '8',
    'sep': '9',
    'oct': '10',
    'nov': '11',
    'dec': '12'
}

glist = [
    "Biographies and Memoirs",
    "Business and Money",
    "Calendars",
    "Children's Books",
    "Comics and Graphic Novels",
    "Computers and Technology",
    "Cookbooks, Food and Wine",
    "Crafts, Hobbies and Home",
    "Christian Books and Bibles",
    "Engineering and Transportation",
    "Health, Fitness and Dieting",
    "History",
    "Humor and Entertainment",
    "Law",
    "Literature and Fiction",
    "Medical Books",
    "Mystery, Thriller and Suspense",
    "Parenting and Relationships",
    "Politics and Social Sciences",
    "Reference",
    "Religion and Spirituality",
    "Romance",
    "Science and Math",
    "Science Fiction and Fantasy",
    "Self-Help",
    "Sports and Outdoors",
    "Teen",
    "Test Preparation",
    "Travel"
]
new_df = pd.DataFrame(glist)

for i in range(0, len(book_df)):
    tmp_date = list(book_df.values[i, 7])
    tmp_data = date_converter[(book_df.at[i, 'date'][0:3]).lower()]
    tmp_date.pop(0) 
    tmp_date.pop(1)
    tmp_date[0] = tmp_data[0]
    output_str = "".join(tmp_date)
    book_df.at[i, 'date'] = output_str

try:
    #create connection
    #connect('user', 'password', 'host port and service')
    dsn = cx_Oracle.makedsn("localhost", 1521, sid="orcl")
    connection = cx_Oracle.connect("BOSS", "bosspassesbook", dsn)
except Exception as err:
    print('Error when connecting to database', err)
else:
    print(connection.version)
    try:
        cur = connection.cursor()
        sql_book_insert = """
        BEGIN
            books_pck.book_insert(:v_amazon_id, :v_img_url, :v_title, :v_author, :v_price, :v_cat_id, :v_date);
        END;
        """

        sql_genres_insert = """
        BEGIN
        books_pck.category_insert(:v_category_name);
        END;
        """

        sql_category_insert = """
        BEGIN
            books_pck.category_insert('Biographies and Memoirs');
        END;
        """
        for i in range(0, len(new_df)):
            cur.execute(sql_genres_insert,
                        v_category_name = str(new_df.values[i, 0])
                    )

        for i in range(0, len(book_df)):
            # print(book_df.values[i, 1],book_df.values[i, 2],book_df.values[i, 3],book_df.values[i, 4],book_df.values[i, 5],book_df.values[i, 6],book_df.values[i, 7],book_df.values[i, 8])
            cur.execute(sql_book_insert,
                    v_amazon_id = str(book_df.values[i, 1]),
                    v_img_url = str(book_df.values[i, 2]),
                    v_title = str(book_df.values[i, 3]),
                    v_author = str(book_df.values[i, 4]),
                    v_price = str(book_df.values[i, 5]),
                    v_cat_id = int(book_df.values[i, 6]),
                    v_date = str(book_df.values[i, 7])
                )
    except Exception as nani:
        print('Error when inserting data to db', nani)
    else:
        print('Insert completed.')
finally:
    cur.close()
    connection.close()

print(book_df.values[12, 7])
print(type((book_df.values[12, 7])))