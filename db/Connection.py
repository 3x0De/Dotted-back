import psycopg

def Connect(func):
    def wrapper(*args, **kwargs):
        conn = psycopg.connect(
            host="db",
            port=5432,
            dbname="app_db",
            user="postgres",
            password="postgres"
        )
        cur = conn.cursor()

        try:
            result = func(cur, *args, **kwargs)
            conn.commit()
            return result
        finally:
            cur.close()
            conn.close()

    return wrapper

@Connect
def Get(cur, cmd, params=None):
    cur.execute(cmd, params)
    return cur.fetchall()

@Connect
def Exec(cur, cmd, params=None):
    cur.execute(cmd, params)