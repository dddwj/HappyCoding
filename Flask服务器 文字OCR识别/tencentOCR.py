# coding = utf-8
import requests
import time
import random
import hmac
import hashlib
import base64
import re

def getVerCode(VerCodeAddress):
    appid = "xxx"
    bucket = "imageOCR"
    secret_id = "xxx"
    secret_key = "xxx"
    expired = time.time() + 2592000
    current = time.time()
    rdm = ''.join(random.choice("0123456789") for i in range(10))

    info = "a=" + appid + "&b=" + bucket + "&k=" + secret_id + "&e=" + str(expired) + "&t=" + str(current) + "&r=" + str(rdm) + "&f="
    signindex = hmac.new(bytes(secret_key,'utf-8'), bytes(info,'utf-8'), hashlib.sha1).digest()
    sign = base64.b64encode(signindex + bytes(info,'utf-8'))
    # print(sign)


    headers = {
        "Host": 'recognition.image.myqcloud.com',
        "Authorization": sign
        # "Content-Type": "multipart/form-data"
    }
    url = 'http://recognition.image.myqcloud.com/ocr/general'

    files = {
        'appid': appid,
        'bucket': bucket,
        # "url": "http://inquiry.ecust.edu.cn/jsxsd/verifycode.servlet"
        # "url": "https://www.2345.com/right/homepage/img/block1701172010/20180919000529.png"
        'image': open(VerCodeAddress, 'rb')
    }

    res = requests.post(url, files=files, headers=headers)

    print(res.text)



    find = re.finditer(r'"character":"\w",', res.text)
    vercode = ""
    for match in find:
        vercode += str(match.group())[13]
    # print(vercode)
    return vercode
