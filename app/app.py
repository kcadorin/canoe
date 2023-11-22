#!/usr/bin/python3

from flask import Flask, request, jsonify
import time

app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def hello():
    return jsonify(message='Hello World!'), 200

@app.route('/current-time', methods=['GET'])
def current_time():
    name = request.args.get('name', 'anonymous')
    timestamp = int(time.time())
    return jsonify(timestamp=timestamp, message=f'Hello {name}'), 200

@app.route('/healthcheck', methods=['GET'])
def healthcheck():
    response = {
        'status_code': 200,
        'message': 'Service is healthy',
    }
    return jsonify(response), 200

@app.before_request
def log_request():
    # Log the request
    print({
        'method': request.method,
        'url': request.url,
        'headers': dict(request.headers),
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S'),
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)
