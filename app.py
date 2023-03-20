# using flask_restful
from flask import Flask, jsonify, request, session,abort
from flask_restful import Resource, Api
from flask_mysqldb import MySQL
from datetime import datetime
import requests

# creating the flask app
app = Flask(__name__)
# creating an API object
api = Api(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
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


class temp(Resource):

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

        cursor.execute(
            "select quantity, type from inventory_present_at where mess_id = %s", [mess_id])

        inventory1 = cursor.fetchall()
        inventory = []
        for i in range(len(inventory1)):
            inventory.append((inventory1[i][0], inventory1[i][1]))

        # print(inventory)
        # print(inventory[0][0])
        inventory_list = []
        for item in inventory:
            inventory_list.append((float(item[0]), item[1]))
        print(inventory_list)

        # , 'inventory': inventory})
        cursor.execute(
            "select product_id,quantity,in_date,expiry from stock_contains where mess_id = %s", [mess_id])

        stock = cursor.fetchall()
        cursor.close()
        stock_list = []
        # for item in stock:

        # print(stock)

        return jsonify({'menu': menu, 'contractor': contractor, 'feedback': feedback, 'wastage': str(wastage), 'inventory': str(inventory_list)})


class mess(Resource): #/api/messes

    def get(self):
        cursor = mysql.connection.cursor()

        cursor.execute(
            'select mess_id,mess_name, num_of_employee, number_of_student from `mess`')
        
        mess_list = cursor.fetchall()
        print(mess_list)
        return_obj = []
        for item in mess_list:
            d = {"Mess Id":item[0],"Mess Name":item[1],"Num of Employee":item[2],"No. of Student":item[3]}
            return_obj.append(d)
        cursor.close()

        return jsonify(return_obj)


class student_get(Resource):  # /api/students?mess_id = {mess_id} - list of students 

    def get(self, mess_id=1):
        mess_id = request.args.get('mess_id')
        cursor = mysql.connection.cursor()
        if(mess_id == None):
            cursor.execute('select s.roll_number,s.name,m.mess_name, s.email, s.gender,s.mess_id from `student_allocated` as s,`mess` as m where s.mess_id = m.mess_id')
        else:
            cursor.execute('select s.roll_number,s.name,m.mess_name, s.email, s.gender,s.mess_id from `student_allocated` as s,`mess` as m where s.mess_id = m.mess_id and s.mess_id = %s',[mess_id])
        student_out = cursor.fetchall()
        cursor.close()
        print(student_out)
        student_list = []
        for item in student_out:
            d = {'Roll Number':item[0],'Name':item[1],'Mess Name':item[2],'Email':item[3],'Gender':item[4],'Mess_id':item[5]}
            student_list.append(d)
        return jsonify(student_list)
    
class student_delete(Resource):  # /api/students/delete?roll_no=19110101
    def get(self):
        print("Deleteting student")
        roll_no = request.args['roll_no']
        cursor = mysql.connection.cursor()
        # SET FOREIGN_KEY_CHECKS=0;
        cursor.execute('SET FOREIGN_KEY_CHECKS=0')
        cursor.execute('delete from `student_allocated` where roll_number=%s',[roll_no])
        student_out = cursor.fetchall()
        cursor.close()
        print("Deleted output: ",student_out)
        mysql.connection.commit()
        return jsonify("Deleted roll number {}".format(roll_no))

class student_update(Resource): 
#  myobj = {'roll_no': 19110104,
#                  'name' : "my_newName",
#                  'email' : "joblessmf@unknown.com",
#                  'mess_id':2,
#                  'password':"new_password",
#                  'gender' : 'male'
#                  }
    def post(self):
        print("Student Update")
        print(request.json)

        roll_no = request.json.get('Roll Number')
        mess_id = request.json.get('Mess_id')
        name = request.json.get('Name')
        email = request.json.get('Email')
        password = request.json.get('password')
        gender = request.json.get('Gender')
        cursor = mysql.connection.cursor()
        print("Roll no:", roll_no)
        cursor.execute("select roll_number,name, email, gender,mess_id,password from `student_allocated` where roll_number=%s",[roll_no])
        old_student_data = cursor.fetchone()
        _,old_name,old_email,old_gender,old_mess_id,old_password = old_student_data
        

        name = old_name if name == None else name
        email = old_email if email == None else email
        gender = old_gender if gender == None else gender
        mess_id = old_mess_id if mess_id == None else mess_id
        password = old_password if password == None else password

        cmd = 'update student_allocated set mess_id={},name="{}",email="{}",password="{}",gender="{}" where roll_number=%s'.format(mess_id,name,email,password,gender)
        output = cursor.execute(cmd,[roll_no])
        mysql.connection.commit()
        return("Updated")
    
class student_add(Resource): 
# Sample post request object
#  myobj = {'roll_no': 19110104,
#                  'name' : "my_newName",
#                  'email' : "joblessmf@unknown.com",
#                  'mess_id':2,
#                  'password':"new_password",
#                  'gender' : 'male'
#                  }
    def post(self):
        roll_no = request.json.get('Roll Number')
        mess_id = request.json.get('Mess_id')
        name = request.json.get('Name')
        email = request.json.get('Email')
        password = request.json.get('password')
        gender = request.json.get('Gender')
        cursor = mysql.connection.cursor()
        output = cursor.execute('insert into student_allocated values (%s,%s,%s,%s,%s,%s)',[roll_no,mess_id,name,email,password,gender])
        mysql.connection.commit()
        return("Added")
class post_request(Resource):  # /api/students/update?roll_no = {roll_no}&name={new_name}... - update student
# http://127.0.0.1:5000/api/students/update?roll_no=19110104&name=shiva&mess_id=3&email=vp.shivasan@iitgn.ac.in&password=fluffy&gender=male
    def get(self):

        url = 'http://127.0.0.1:5000/api/students/update'
        myobj = {'roll_no': 19110104,
                 'name' : "my_newName",
                 'email' : "joblessmf@unknown11.com",
                 'mess_id':3,
                 'password':"new_password"
                 }
        
        # url = 'http://127.0.0.1:5000/api/students/add'
        # myobj = {'roll_no': 19110101,
        #          'name' : "101_name______",
        #          'email' : "joblessmf_101@unknown11.com",
        #          'mess_id':2,
        #          'password':"new_password",
        #          'gender':"female"
        #          }
        # url = 'http://127.0.0.1:5000/api/register'
        # myobj = {'username': "shiva",
        #          'password' : "yoyoyo",
        #          }
        x = requests.post(url, json = myobj)

        return(x.text)


# adding the defined resources along with their corresponding urls
api.add_resource(student_get, '/api/students')
api.add_resource(student_delete, '/api/students/delete')
api.add_resource(student_update, '/api/students/update')
api.add_resource(student_add, '/api/students/add')
api.add_resource(mess, '/api/messes')
api.add_resource(post_request, '/api/post_request')



# driver function
if __name__ == '__main__':

    app.run(debug=True)