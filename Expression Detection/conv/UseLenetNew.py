from keras.optimizers import SGD, Adam
from conv import LeNet_New


# 初始化模型
print("initialize the model...")
model = LeNet_New.build(width=28, height=28, depth=1, classes=2)
adam = Adam()
model.compile(loss="binary_crossentropy", optimizer=adam, metrics=["accuracy"])
# print(model.get_layer(index=6).input_shape)
# print(model.get_layer(index=6).output_shape)
# print(model.get_layer(index=6).shape)
model.summary()