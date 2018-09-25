from flask import *
from flask_cors import *
import tencentOCR
import os
from datetime import datetime


app = Flask(__name__)
CORS(app, supports_credentials=True)
# UPLOAD_FOLDER = './static'
# app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER#设置文件下载路径
UPLOAD_ADDRESS = "~/PycharmProjects/VerCodeServer/static/"

@app.route('/', methods=['GET',"POST"])
def index():
    return "<h1>hello!</h1>"


@app.route('/VerCodeAPI',methods=['get','post'])
def Test():
    if request.method=='GET':
        print(request.data)
        print(request.get_data())
        rst = make_response('Please use OPTIONS or POST method.')
        rst.headers['Access-Control-Allow-Origin'] = '*' #任意域名 跨域访问
        return rst
    else:
        # print(request.files)
        f = request.files['file']
        f.save(UPLOAD_ADDRESS + "vercode.png")
        if f:
            print(f)
        else:
            print("No file!")
        # print(request.data)
        # print(request.headers)
        # print(request.get_json())
        # print(request.form)

        vercode = tencentOCR.getVerCode(UPLOAD_ADDRESS + "vercode.png")
        print(vercode)
        if(vercode.__len__() < 5 ):
            os.rename(UPLOAD_ADDRESS + "vercode.png", UPLOAD_ADDRESS + datetime.now().strftime('%Y-%m-%d') + "__" + vercode + ".png"  )

        rst = make_response(vercode)
        rst.status_code = 200
        rst.headers['Access-Control-Allow-Origin'] = '*'
        rst.headers['Access-Control-Allow-Methods'] = 'POST' #响应POST
        return rst


if __name__ == '__main__':
    app.run()
