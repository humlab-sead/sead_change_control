import sqlalchemy
import pathlib
import os
import pgpasslib

def get_db_uri(dbname, host=None, user=None):
    
    server_name = host or pathlib.Path(os.path.expanduser('~/.default.sead.server')).read_text().rstrip()
    user_name = user or pathlib.Path(os.path.expanduser('~/.default.sead.username')).read_text().rstrip()

    password = pgpasslib.getpass(host=server_name, port='5432', dbname=dbname, user=user_name)
    
    if not password:
        raise ValueError('Did not find a password in the .pgpass file')

    uri = "postgresql://{}:{}@{}/postgres".format(user_name, password, server_name, dbname)
    
    return uri

def get_db_engine(dbname, host=None, user=None):
    uri = get_db_uri(dbname, host, user)
    engine = sqlalchemy.create_engine(uri)
    return engine