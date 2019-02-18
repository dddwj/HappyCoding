import os
import urllib.request
import re
import subprocess
files = os.listdir('./files/')
s = []

# Shell 命令，需要先安装ffmpeg
def downM3U8(url, path):
    path = path + '.mp4'
    cmd = "ffmpeg -protocol_whitelist file,http,https,crypto,tcp -i %s %s" % (url, path)
    print(cmd)
    subprocess.call(cmd, shell=True)

for file in files:
    if file == '.DS_Store':
        continue
    dirName = re.split(r'.txt|.m3u8$', file)[0].replace(' ', '')
    os.makedirs(dirName)

    # 直接下载.m3u8文件
    if file.endswith('.m3u8'):
        downM3U8(url="./files/" + file.replace(' ','\ '), path='./%s/video'% dirName)

    # 读取txt文件后下载：1. jpg图片 2. m3u8视频
    if file.endswith('.txt'):
        f = open("./files/" + file, "r")
        count = 0
        downList = []
        while 1:
            line = f.readline()
            if not line:
                break
            else:
                count += 1
            if line.endswith('.jpg\n') or line.endswith('.png\n'):
                urllib.request.urlretrieve(line, "./%s/ppt_%s.jpg"%(dirName, count))
            if line.endswith('.m3u8\n'):
                downList.append(line)
        for (idx,line) in enumerate(downList[0:-1]):    # 每个txt文件最后的m3u8地址中的视频内容与之前的重复
            downM3U8(url=line.split('\n')[0], path='./%s/video_%s' % (dirName, idx))
