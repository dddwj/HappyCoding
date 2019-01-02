from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from keras.preprocessing.image import img_to_array
from keras.utils import np_utils
from keras.optimizers import SGD, Adam
from keras.models import load_model
import keras.backend as K
from keras import callbacks
from math import floor
from conv import LeNet
from conv import LeNet_New
from conv import LeNet_New_VGG
import matplotlib.pyplot as plt
import numpy as np
import argparse
import tools
import cv2
import os

# 命令行参数
ap = argparse.ArgumentParser()
ap.add_argument("-d", "--dataset", required=True)
ap.add_argument("-m", "--model", required=True)
args = vars(ap.parse_args())

# 数据和标签列表
data = []
labels = []
epoch = 10  # default: 15

# 遍历每一张样本图片
for imagePath in sorted(list(tools.list_images(args["dataset"]))):
    image = cv2.imread(imagePath)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    image = tools.resize(image, width=28)
    image = img_to_array(image)
    data.append(image)

    # 样本图片路径smiles/positives/positives7/13229.jpg
    label = imagePath.split(os.path.sep)[-3]
    label = "smiling" if label == "positives" else "not_smiling"
    labels.append(label)

# 缩放到[0,1]
# print(data[0][0])
data = np.array(data, dtype="float") / 255.0
# print(data[0][0])
# print(np.info(data))
labels = np.array(labels)

# 将标签Onehot
le = LabelEncoder().fit(labels)
labels = np_utils.to_categorical(le.transform(labels), 2)

# 计算权重
classTotals = labels.sum(axis=0)
classWeight = classTotals.max() / classTotals

# 80%用于训练，20%用于测试
(trainX, testX, trainY, testY) = train_test_split(data, labels, test_size=0.20, stratify=labels, random_state=42)
# print(np.info(testX))

# 初始化模型
print("initialize the model...")
# model = LeNet.build(width=28, height=28, depth=1, classes=2)          # 初始的模型(lenet.hdf5)
# model = LeNet_New_VGG.build(width=32, height=32, depth=3, classes=2)    # transfered VGG
# model = LeNet_New.build(width=28, height=28, depth=1, classes=2)        # a handwritten VGG
model = load_model('./output/lenet.hdf5')                             # 加载老师训练的模型
adam = Adam(lr=0.005)    # 默认是0.001
# adam = Adam()
model.compile(loss="binary_crossentropy", optimizer=adam, metrics=["accuracy"])
# model.summary()
'''
# 设置学习率下降的函数
from keras.callbacks import LearningRateScheduler
def step_decay(epoch):
    # current_lr =  K.get_value(adam.lr)
    # 使用了LearningRateScheduler之后，就不需要使用 K.set_value(sgd.lr, 0.5 * K.get_value(sgd.lr))

    # initial_lrate = 0.1
    # drop = 0.5
    # epochs_drop = 5.0
    # lrate = initial_lrate * pow(drop, floor((1+epoch)/epochs_drop))
    current_lr = K.get_value(adam.lr)   # 也可以用：K.get_value(model.optimizer.lr) ;
    new_lr = current_lr

    print("In Epoch: " + str(epoch+1) + "\t\tlast learning rate:" + str(current_lr))
    return new_lr
lrate = LearningRateScheduler(step_decay, verbose=1)
'''

'''
# 设置学习率下降的另一种方法
from keras.callbacks import ReduceLROnPlateau
reduce_lr = ReduceLROnPlateau(monitor='val_loss', factor=0.1,
                             patience=10, verbose=0, mode='auto', epsilon=0.0001, cooldown=0, min_lr=0)

'''


# 自己设置的回调函数。 监测训练数据、降低学习率。
class LRInspection(callbacks.Callback):
    epoch_count = 0
    train_losses = []
    val_losses = []   # aka. generalization_loss // test_loss
    def on_train_begin(self,log={}):
        self.train_losses = []
        self.val_losses = []
        self.epoch_count = 0
        self.waiting = 0
        self.patience = 1

    def on_epoch_end(self, batch, log={}):
        # self.model.summary()
        epoch_train_loss = log.get('loss')
        epoch_val_loss = log.get('val_loss')
        lr = K.get_value(adam.lr)
        self.train_losses.append(epoch_train_loss)
        self.val_losses.append(epoch_val_loss)
        self.epoch_count += 1
        print("Epoch Summary:" + str(self.epoch_count) + "\n" +
              " loss:" + str(round(log.get('loss'),4)) +
              " val_loss:" + str(round(log.get('val_loss'),4)) +
              " learning_rate:" + str(lr))


        if self.epoch_count == 1:
            return
        delta_train_loss = self.train_losses[-2] - self.train_losses[-1]
        delta_val_loss = abs(self.val_losses[-2] - self.val_losses[-1])

        ## 如果train_loss 下降变缓，且val_loss开始上升或变平缓：此时才考虑下降学习率
        if  delta_val_loss < 0.03:
            if self.waiting < self.patience:
                self.waiting += 1
            else:
                self.waiting = 0
                new_lr = lr / 2
                if new_lr < 0.0001:
                    self.model.stop_training = True
                    print("Note: Learning Rate is lower than 0.0005. \nEarly Stop!")
                else:
                    K.set_value(adam.lr, new_lr)
                    print("Note: Next Learning Rate is reset to: " + str(K.get_value(adam.lr)))
        else:
            self.waiting = 0
        print("waiting: %s" % self.waiting)
        # input("continue?")
        print("\n\n")

lr_inspection = LRInspection()


# 输出每一轮的模型误差至csv文件
from keras.callbacks import CSVLogger
csv_logger = CSVLogger('./training.csv', separator=',', append=False)

# 训练模型
print("training network...")
H = model.fit(trainX, trainY, validation_data=(testX, testY),
              class_weight=classWeight, batch_size=64,
              epochs=epoch, verbose=1, callbacks=[csv_logger, lr_inspection])

# 评估模型
print("evaluating network...")
predictions = model.predict(testX, batch_size=64)
print("******")
print(classification_report(testY.argmax(axis=1),
                            predictions.argmax(axis=1), target_names=le.classes_))

# 保存模型
model.save(args["model"])
# json_str = model.to_json()
# print(json_str)

print("network saved")

# 画训练和测试损失和准确率
plt.style.use("ggplot")
plt.figure()
fact_epoch = len(H.history['val_loss'])     # 考虑早停时，需要记录实际训练的轮数
plt.plot(np.arange(0, fact_epoch), H.history["loss"], label="train_loss")
plt.plot(np.arange(0, fact_epoch), H.history["val_loss"], label="val_loss")
plt.plot(np.arange(0, fact_epoch), H.history["acc"], label="acc")
plt.plot(np.arange(0, fact_epoch), H.history["val_acc"], label="val_acc")
plt.title("Loss and Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Loss/Accuracy")
plt.legend()
plt.show()