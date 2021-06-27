from robot.api.deco import library
import pyodbc

"""
Library for communication with Azure - Database

Must by defined only KEYVAULT where shards configuration is stored.
As driver is used ODBC Driver 17 for SQL Server
"""


@library(scope="GLOBAL", version="0.1", auto_keywords=True)
class azureDB:

    def __init__(self):
        self.db_conf = {}
        self.db_cursors = {}
        self.__load_db_configuration('db_name', 'connection_string')
        self.db_cursors['db_name'] = self.__connect_to_database('db_name').cursor()

    def __load_db_configuration(self, db_name: str, connection_string: str):
        config = dict(s.split('=', 1) for s in connection_string.split(';') if s)
        self.db_conf[db_name] = {
            'server': config.get('Server'),
            'database': config.get('Database'),
            'user_id': config.get('User ID'),
            'password': config.get('Password'),
            'trusted_connection': 'yes' if config.get('Trusted_Connection') else 'no',
            'encrypt': 'yes' if config.get('Encrypt') else 'no',
        }

    def __connect_to_database(self, db_id):
        connect = pyodbc.connect(
            "Driver={ODBC Driver 17 for SQL Server};"
            "Server=" + self.db_conf[f'{db_id}']['server'] + ";"
            "Database=" + self.db_conf[f'{db_id}']['database'] + ";"
            "Uid=" + self.db_conf[f'{db_id}']['user_id'] + ";"
            "Pwd=" + self.db_conf[f'{db_id}']['password'] + ";"
            "Encrypt=" + self.db_conf[f'{db_id}']['encrypt'] + ";"
            "TrustServerCertificate=no;"
            "Connection Timeout=30;"
        )
        return connect

    def select_from_database(self, db_id, query):
        result = []
        cursor = self.db_cursors[db_id]
        cursor.execute(query)
        row = cursor.fetchone()
        while row:
            result.append(row)
            row = cursor.fetchone()
        return result

    def delete_from_database(self, db_id, delete_cmd):
        conn = self.__connect_to_database(db_id)
        cursor = conn.cursor()
        try:
            cursor.execute(delete_cmd)
        except:
            cursor.rollback()
        else:
            conn.commit()
        pass
