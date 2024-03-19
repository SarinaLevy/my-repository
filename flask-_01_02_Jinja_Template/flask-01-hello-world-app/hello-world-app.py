from flask import Flask 
app = Flask(__name__)

@app.route('/')
def hello():
    return "hello world"



@app.route('/sarina')
def sarina():
    return "This is the sarinas page"

@app.route('/george/subthird')
def george():
    return "This is the subpage of third page"

@app.route('/forth/<string:my_id>')
def forth(my_id):
    return "The page id is {my_id}"

if __name__ == '__main__':

    app.run(debug=True)
    # app.run(host= '0.0.0.0', port=8081)