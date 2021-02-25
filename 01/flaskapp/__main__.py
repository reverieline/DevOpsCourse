from flask import Flask, request, jsonify, render_template
from random import random
from waitress import serve

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
    json = request.get_json()
    char = randomchr()

    try: json["word"]
    except: word = "Hello!"
    else: word = json["word"]

    try: json["count"]
    except: count = 1
    else: count = json["count"]

    return ((char+word) * count + char, 200)

if __name__ == '__main__':
  # app.run(debug = True, port = 5000, host = "0.0.0.0")
  serve(app, host='0.0.0.0', port=80)