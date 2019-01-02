from keras.models import load_model
from keras.models import Sequential
from keras.preprocessing.image import img_to_array
import numpy as np
import cv2
import tools

def tell(path):
    # print(model.to_json())

    # import h5py as h5
    # h = h5.File("./output/lenet.hdf5","r")
    # print(h.keys())

    # image = cv2.imread("./smiles/positives/positives7/24.jpg")
    image = cv2.imread(path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    image = tools.resize(image, 28)

    cv2.imwrite("./smiles/mine/mine_proc.jpg", image)
    image = img_to_array(image)
    data = []
    data.append(image)
    data = np.array(data, dtype="float") / 255.0
    # print(np.info(data))
    if not image.any():
        print("No image input!")
    else:
        model = load_model('./output/lenet.hdf5')
        predict = model.predict(data)
        print(predict)
        if predict.argmax(axis=1)[0]:   # positive = 1， negative = 0
            print("Positive!")
        else:
            print("Negative!")

if __name__ == '__main__':
  # tell("./smiles/negatives/negatives7/5.jpg")
  # tell("./smiles/positives/positives7/54.jpg")
  tell("./smiles/mine/face0.jpg")
