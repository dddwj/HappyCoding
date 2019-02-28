# 实时视频图像表情识别 Realtime Facial Expression Recognition System

### 功能与技术

+ 实时视频中检测人脸  [`OpenCV cascade classifier`分类器]
+ 二分类模型识别表情：笑/不笑
+ 模型准确度不高，可能原因：
  - 数据集不完整
  - 自己搭建的模型不够复杂
+ 基于Python - Keras包构建的卷积神经网络模型
+ 其它功能：迁移学习、学习率下降



### 训练方式

`python train.py --dataset ./smiles --model ./output/lenet3.hdf5`

+ 训练前，需要先在smiles文件夹中放入训练用的数据集(negatives 和 postives两个文件夹)
+ 加载模型/输出训练后的模型，在输入参数
+ 运行train.py



### 运行方式

`python detect_expression.py --cascade haarcascade_frontalface_default.xml --model ./output/lenet.hdf5`

+ 使用detect_expression.py：借助opencv开启电脑摄像头，实时判读人脸表情，实现系统功能

+ 使用tell.py：输入一张图片，由控制台输出笑/不笑的概率

+ 使用face_dection.py：实时检测并标注人脸

