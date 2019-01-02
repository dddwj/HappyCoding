from keras.applications.vgg16 import VGG16
from keras.models import Model
from keras.layers import Dense, Activation, Dropout, Flatten

class LeNet_New_VGG:
    @staticmethod
    def build(height, width, depth, classes):
        inputShape = (height, width, depth)     # VGG模型 要求inputshape尺寸必须至少32*32，必须是3通道的。
        bottomModel = VGG16(weights="imagenet",include_top=False, input_shape=inputShape, classes = classes)
        # 当include_top为true时，输入的必须为(224,224,3) classes必须为3。
        # ？？ 想不通。使用top的几层时，如何受到bottom输入层影响？
        for layer in bottomModel.layers:
            layer.trainable = False

        # 再另加几层
        topModel = bottomModel.output
        # ?? 如何设计层次？
        # topModel = Flatten("channels_last")(topModel)
        topModel = Dense(classes)(topModel)
        topModel = Activation("relu")(topModel)
        topModel = Dropout(0.2)(topModel)
        topModel = Activation("softmax")(topModel)

        model = Model(inputs=bottomModel.input, outputs=topModel)
        model.summary()   # 获取模型配置
        # print(model.layers[-1].get_config())  # 获取最后一层配置

        # from keras.utils.vis_utils import plot_model
        # plot_model(model, to_file='./model1.png', show_shapes=True) # 将模型可视化输出到png图像中
        return model

c = LeNet_New_VGG()
c.build(54,54,3,2)