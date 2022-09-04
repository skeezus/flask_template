from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://{db_user}:{db_pass}@{db_ip}:{db_port}/{db_name}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)


@app.route('/health')
def health():
    return 'Ok'


@app.route('/health/db')
def health_db():
    db.session.execute('SELECT 1')
    return 'Ok'
