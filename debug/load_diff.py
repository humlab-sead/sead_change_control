import pandas as pd
from sqlalchemy import create_engine


def load_it(filename: str, tablename: str):

    server_name = open("/home/roger/vault/.default.sead.server", "r").read().strip()
    user_name = open("/home/roger/vault/.default.sead.username", "r").read().strip()

    df = pd.read_csv(filename)
    df.columns = [c.lower().replace(' ','') for c in df.columns] # PostgreSQL doesn't like capitals or spaces

    for col in df.columns:
        if '_id_' in col:
            df[col] = df[col].fillna(-1).astype(int)
        else:
            df[col] = df[col].fillna('').str.strip("'")

    engine = create_engine(f'postgresql://{user_name}@{server_name}:5432/sead_staging')

    df.to_sql(tablename, engine, if_exists='replace', index=False)


if __name__ == "__main__":
    # load_it('debug/data/tbl_dataset_submissions.csv', 'tbl_dataset_submissions_temp')
    load_it('debug/data/tbl_sample_alt_refs.csv', 'tbl_sample_alt_refs_temp')

# # Set it so the raw SQL output is logged
# import logging
# logging.basicConfig()
# logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# df.to_sql("my_table_name2",
#           engine,
#           if_exists="append",  # Options are ‘fail’, ‘replace’, ‘append’, default ‘fail’
#           index = False, # Do not output the index of the dataframe
#           dtype = {'col1': sqlalchemy.types.NUMERIC,
#                    'col2': sqlalchemy.types.String}) #

