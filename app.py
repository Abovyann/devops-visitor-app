from flask import Flask
import redis
import os

app = Flask(__name__)

redis_host = os.environ.get('REDIS_HOST', 'localhost')
cache = redis.Redis(host=redis_host, port=6379)

def get_hit_count():
    try: 
        return cache.incr('hits')
    except redis.exceptions.ConnectionError as exc:
        return "Redis is not connected yet."
    
@app.route('/')
def hello():
    count = get_hit_count()
    if isinstance(count, int):
        return f"Hello! This page has been viewed {count} times."
    else: 
        return f"Hello, {count}"
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)