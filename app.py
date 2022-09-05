import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("FLASK_TEMPLATE_DB_URI")
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


@app.route('/health')
def health():
    return 'Ok'


@app.route('/health/db')
def health_db():
    db.session.execute('SELECT 1')
    return 'Ok'
