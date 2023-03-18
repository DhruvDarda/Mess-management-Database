# using flask_restful
from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from flask_mysqldb import MySQL

# creating the flask app
app = Flask(__name__)
# creating an API object
api = Api(app)

'''
app.config['MYSQL_HOST'] = 'sql12.freemysqlhosting.net'
app.config['MYSQL_USER'] = 'sql12606313'
app.config['MYSQL_PASSWORD'] = 'NeGfrFa9uy'
app.config['MYSQL_DB'] = 'sql12606313'
'''

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mysql@123'
app.config['MYSQL_DB'] = 'mess_management'

mysql = MySQL(app)


class Hello(Resource):

    # corresponds to the GET request.
    # this function is called whenever there
    # is a GET request for this resource
    def get(self):
        data = request.get_json()
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM `mess`")
        result = cursor.fetchall()
        cursor.close()
        return jsonify({'message': result})

    # Corresponds to POST request
    def post(self):
        data = request.get_json()
        cursor = mysql.connection.cursor()
        result = cursor.execute("SELECT * FROM `mess`")
        # mysql.connection.commit()
        cursor.close()
        return jsonify({'data': result}), 201


# another resource to calculate the square of a number
class Square(Resource):

    def get(self, num):

        return jsonify({'square': num**2})


# adding the defined resources along with their corresponding urls
api.add_resource(Hello, '/')
api.add_resource(Square, '/square/<int:num>')


# driver function
if __name__ == '__main__':

    app.run(debug=True)
