# import the necessary packages
from keras.models import Sequential
from keras.layers.convolutional import Conv2D
from keras.layers.convolutional import MaxPooling2D
from keras.layers.core import Activation
from keras.layers.core import Flatten
from keras.layers.core import Dense
from keras.layers.core import Dropout
from keras.layers.normalization import BatchNormalization
from keras import layers
from keras import backend as K

# 自己设置的模型 （task.docx中的任务2）
class LeNet_New:
    @staticmethod
    def build(width, height, depth, classes):
        # initialize the model
        model = Sequential()
        inputShape = (height, width, depth)   # 28*28*1


        model.add(Conv2D(filters=28, kernel_size=(3,3), padding="same", input_shape=inputShape))
        # padding = "SAME":  不够卷积核大小的块就补充0  padding = "VALID":不够卷积核大小的块就丢弃.
        # ref: https://oldpan.me/archives/tf-keras-padding-vaild-same
        # 首层需要使用inputShape指明输入的尺寸。
        # ??? K = 28是滤波器filters的尺寸？ 答：类似于相机滤镜。
        model.add(Activation("relu")) # chocies: https://keras.io/activations/
        model.add(BatchNormalization())     # ref: https://keras-cn.readthedocs.io/en/latest/layers/normalization_layer/
                                            # Batch Normalization: https://www.youtube.com/watch?v=-5hESl-Lj-4
        model.add(Conv2D(filters=28, kernel_size=(3,3), padding="same"))
        model.add(Activation("relu"))
        model.add(BatchNormalization())

        model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))# pool_size: 取（2，2）将使图片在两个维度上均变为原长的一半。
                                                                # stride: (2,2) 步长
                                                                # 池化层： 简化网络计算复杂度；进行特征压缩
        model.add(Dropout(0.2))  # Dropout将在训练过程中每次更新参数时随机断开一定百分比（p）的输入神经元连接，Dropout层用于防止过拟合。

        # 再重复一次
        model.add(Conv2D(filters=56, kernel_size=(3, 3), padding="same", input_shape=inputShape))
        # ??? 怎么会再扩展到56？
        model.add(Activation("relu"))
        model.add(BatchNormalization())
        model.add(Conv2D(filters=56, kernel_size=(3, 3), padding="same"))
        model.add(Activation("relu"))
        model.add(BatchNormalization())
        model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
        model.add(Dropout(0.2))

        # 全连接FC层(先要压平，再全连接)
        # ??? 如何理解？
        # ??? 为什么是500？是否有丢失？
        model.add(Flatten())
        model.add(Dense(500))
        model.add(Activation("relu"))
        model.add(BatchNormalization())
        model.add(Dropout(0.2))

        model.add(Dense(classes))
        model.add(Activation("softmax"))

        # return the constructed network architecture
        return model
