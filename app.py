# using flask_restful
from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from flask_mysqldb import MySQL
from datetime import datetime

# creating the flask app
app = Flask(__name__)
# creating an API object
api = Api(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mysql@123'
app.config['MYSQL_DB'] = 'mess_management'

mysql = MySQL(app)


def return_current_day_slot():
    dt = datetime.now()
    day = dt.strftime('%A').lower()
    # print(day)
    hour = dt.hour
    if(hour < 12):
        slot = "breakfast"
    elif(hour < 4):
        slot = "lunch"
    elif(hour < 6):
        slot = "snacks"
    else:
        slot = "dinner"
    return {"slot": slot, "Day": day}


def return_current_date_slot():
    today = datetime.now()
    date = today.strftime('%Y-%m-%d')
    slot = return_current_day_slot()['slot']
    return {'date': date, 'slot': slot}


class student(Resource):

    def get(self, mess_id=1):
        cursor = mysql.connection.cursor()
        dayslotno = return_current_day_slot()
        dateslotno = return_current_date_slot()
        day = 'tuesday'
        date = '2023-01-02'
        slot = 'breakfast'

        cursor.execute(
            'select dayslot_id from `day_slot` where day_sl = "{}" and slot = "{}"'.format(day, slot))
        dayslot = cursor.fetchone()[0]

        #print("dayslot", dayslot)

        cursor.execute(
            "select mi.item_name, mi.price, mi.is_special from `mess_item` as mi, `menu` as m where m.dayslot_id = %s and m.item_id = mi.item_id", [dayslot])
        menu = cursor.fetchall()

        cursor.execute(
            "select contractor_name from contractor_manages where mess_id = %s", [mess_id])

        contractor = cursor.fetchall()

        cursor.execute(
            "select star_rating, comment from feedback_received where mess_id = %s", [mess_id])

        feedback = cursor.fetchall()

        cursor.execute(
            'select date_slot_id from `date_slot` where date = "{}" and slot = "{}"'.format(date, slot))
        dateslot = cursor.fetchone()[0]
        cursor.execute(
            "select food_wasted from wastage where mess_id = %s and date_slot_id = %s", [mess_id, dateslot])

        wastage = cursor.fetchone()[0]
        print(wastage)

        cursor.close()
        return jsonify({'menu': menu, 'contractor': contractor, 'feedback': feedback, 'wastage': str(wastage)})


class Hello(Resource):

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
        return jsonify({'data': 'result'}), 201


# another resource to calculate the square of a number
class Square(Resource):

    def get(self, num):

        return jsonify({'square': num**2})


# adding the defined resources along with their corresponding urls
api.add_resource(student, '/')
api.add_resource(Square, '/square/<int:num>')


# driver function
if __name__ == '__main__':

    app.run(debug=True)
