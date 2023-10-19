from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    data = [1.0, 2.0, 3.0, 4.0, 5.1]  # Example array; array of the doubles.
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
