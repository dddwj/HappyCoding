from keras.preprocessing.image import img_to_array
from keras.models import load_model
import numpy as np
import argparse
import tools
import cv2

ap = argparse.ArgumentParser()
ap.add_argument("-c", "--cascade", required=True)
ap.add_argument("-m", "--model", required=True)
args = vars(ap.parse_args())

detector = cv2.CascadeClassifier(args["cascade"])
model = load_model(args["model"])

camera = cv2.VideoCapture(0)

while True:
    (grabbed, frame) = camera.read()

    frame = tools.resize(frame, width=900)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    frameNew = frame.copy()

    # 在灰度图上检测人脸，得到所有矩形。
    rects = detector.detectMultiScale(gray, scaleFactor=1.1,
                                      minNeighbors=5, minSize=(30, 30),
                                      flags=cv2.CASCADE_SCALE_IMAGE)

    # 循环每一个检测出人脸的矩形区域
    for (fX, fY, fW, fH) in rects:
        # 抽取ROI区域，缩放为28*28
        roi = gray[fY:fY + fH, fX:fX + fW]
        roi = cv2.resize(roi, (28, 28))
        roi = roi.astype("float") / 255.0
        roi = img_to_array(roi)
        roi = np.expand_dims(roi, axis=0)

        # 得到概率
        (notSmiling, smiling) = model.predict(roi)[0]
        label = "smiling" if smiling > notSmiling else "not smiling"

        # 显示标签和方框
        cv2.putText(frameNew, label, (fX, fY - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.45, (0, 0, 255), 2)
        cv2.rectangle(frameNew, (fX, fY), (fX + fW, fY + fH),
                      (0, 0, 255), 2)

    cv2.imshow("expression detecting", frameNew)

    # 按Q键退出
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

camera.release()
cv2.destroyAllWindows()
