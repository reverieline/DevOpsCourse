from flask import Flask, request, jsonify, render_template
from random import random
import json

app = Flask(__name__)

CHAR_RANGE = (0x0001F300,0x0001FAD6)

def randomchr():
  range = CHAR_RANGE[1] - CHAR_RANGE[0]
  return chr(int(CHAR_RANGE[0] + range*random()))

@app.route("/", methods=["GET","POST"])
def index():
  if request.method == "GET":
    return render_template("index.html", chr1=randomchr(), chr2=randomchr(), host=request.host)
  else:
    # data = request.get_json()
    data = request.get_data()
    try: data = json.loads(data)
    except: pass

    try: data["word"]
    except: word = "Hello!"
    else: word = data["word"]

    try: data["count"]
    except: count = 1
    else: count = data["count"]
    
    char = randomchr()
    return ((char+word) * count + char, 200)
