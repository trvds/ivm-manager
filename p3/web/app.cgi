#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect
import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199335"
DB_DATABASE = DB_USER
DB_PASSWORD = "gaev2698"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)

@app.route("/main_menu")
def main_menu():
    try:
        return render_template("main_menu.html")
    except Exception as e:
        return str(e)


@app.route("/simple_category")
def list_simple_categories():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM simple_category;"
        cursor.execute(query)
        return render_template("simple_category.html", cursor=cursor)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route("/add_simple_category")
def add_simple_category():
    try:
        return render_template("add_simple_category.html")
    except Exception as e:
        return str(e)


@app.route("/new_simple_category", methods=["POST"])
def new_simple_category():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        category = request.form["category"]
        query1 = "INSERT INTO category VALUES (%s);"
        query2 = "INSERT INTO simple_category VALUES (%s);"
        data = (category,)
        cursor.execute(query1, data)
        cursor.execute(query2, data)        
        return render_template("operation_successful.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/delete_simple_category", methods=["POST"])
def delete_simple_category():
    dbConn = None
    cursor = None


@app.route("/super_category")
def list_super_categories():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_category;"
        cursor.execute(query)
        return render_template("super_category.html", cursor=cursor)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route("/add_super_category")
def add_super_category():
    try:
        return render_template("add_super_category.html")
    except Exception as e:
        return str(e)


@app.route("/new_super_category", methods=["POST"])
def new_super_category():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        category = request.form["category"]
        query1 = "INSERT INTO category VALUES (%s);"
        query2 = "INSERT INTO super_category VALUES (%s);"
        data = (category,)
        cursor.execute(query1, data)
        cursor.execute(query2, data)        
        return render_template("operation_successful.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/delete_super_category", methods=["POST"])
def delete_super_category():
    dbConn = None
    cursor = None



@app.route("/subcategory")
def list_subcategories():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        params = request.args
        query = "SELECT category FROM has_other WHERE super_category = %s;"
        data = (params.get("category"),)
        cursor.execute(query, data)
        return render_template("subcategory.html", cursor=cursor, params=params)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route("/add_subcategory")
def add_subcategory():
    try:
        return render_template("add_subcategory.html", params=request.args)
    except Exception as e:
        return str(e)


@app.route("/new_subcategory", methods=["POST"])
def new_subcategory():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        category = request.form["category"]
        subcategory = request.form["subcategory"]
        query = "INSERT INTO has_other VALUES (%s, %s)"
        data = (category, subcategory)
        cursor.execute(query, data)
        return render_template("operation_successful.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/delete_subcategory", methods=["POST"])
def delete_subcategory():
    dbConn = None
    cursor = None

@app.route("/retailer")
def list_retailer():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retailer;"
        cursor.execute(query)
        return render_template("retailer.html", cursor=cursor)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route("/add_retailer")
def add_retailer():
    try:
        return render_template("add_retailer.html")
    except Exception as e:
        return str(e)


@app.route("/new_retailer", methods=["POST"])
def new_retailer():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        name = request.form["name"]
        query = "INSERT INTO retailer VALUES (%s, %s);"
        data = (tin, name)
        cursor.execute(query, data)  
        return render_template("operation_successful.html")
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/delete_retailer", methods=["POST"])
def delete_retailer():
    dbConn = None
    cursor = None



@app.route("/ivm")
def list_ivms():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM ivm;"
        cursor.execute(query)
        return render_template("ivm.html", cursor=cursor)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route("/resupply_event")
def list_resupply_events():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        params = request.args
        serial_number = params.get("serial_number")
        manuf = params.get("manuf")
        query = "SELECT ean, number, instant, units, tin, name FROM resupply_event NATURAL JOIN has_category WHERE serial_number = %s AND manuf = %s ORDER BY name;"
        data = (serial_number, manuf)
        cursor.execute(query, data)
        return render_template("resupply_event.html", cursor=cursor, params=params)
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
