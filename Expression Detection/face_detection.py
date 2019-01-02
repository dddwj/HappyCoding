import argparse
import cv2

# 获取命令行参数
argp = argparse.ArgumentParser()
argp.add_argument("-c", "--cascade", required=True)
args = vars(argp.parse_args())

# 加载Cascade人脸分类器
facedetector = cv2.CascadeClassifier(args["cascade"])

# 获取摄像头
camera = cv2.VideoCapture(0)

while True:
    # 获取当前帧
    (grabbed, frame) = camera.read()

    # 转换为灰度图
    grayframe = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # grayframe = frame
    copyframe = frame.copy()

    # 在灰度图上，用Cascade人脸分类器找到所有的人脸矩形区域，ROI(range of interesting)区域。
    rects = facedetector.detectMultiScale(grayframe, scaleFactor=1.1,
                                          minNeighbors=5, minSize=(30, 30),
                                          flags=cv2.CASCADE_SCALE_IMAGE)

    # 遍历找到的所有脸部区域
    for (fX, fY, fW, fH) in rects:
        # 用红色矩形标出脸部ROI区域
        cv2.rectangle(copyframe, (fX, fY), (fX + fW, fY + fH), (0, 0, 255), 2)

    # 显示
    cv2.imshow("express detection", copyframe)

    # 按下q键，退出循环。
    # if ord("q") == cv2.waitKey(-1) & 0xFF:
    #     break

    faces = []
    if ord("t") == cv2.waitKey(1) & 0xFF:
        print("click!")
        for index, (fX, fY, fW, fH) in enumerate(rects):
            faces.append(frame[fY : fY + fH, fX : fX + fW])     # 二维数组切片，注意x，y顺序
        # 释放摄像头。
        camera.release()
        break


from tell import tell
for index,face in enumerate(faces):
    cv2.imwrite("./smiles/mine/face%s.jpg" % index, face)
    tell("./smiles/mine/face%s.jpg" % index)

cv2.waitKey(0)
cv2.destroyAllWindows()
