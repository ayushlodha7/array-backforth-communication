from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/data', methods=['POST'])
def receive_array():
    try:
        # Receive data as a comma-separated string
        data = request.data.decode('utf-8')
        # Convert string to a list of floating-point numbers
        array = [float(x) for x in data.split(",")]

        print("Received array:", array)
        return "Array received successfully", 200
    except Exception as e:
        return str(e), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
