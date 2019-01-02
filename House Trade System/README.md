# 房产交易市场

### 功能介绍

1. 查房买房（按小区搜索、按板块搜索）
2. 挂牌卖房
3. 管理房屋（修改挂牌价、修改房屋信息）
4. （未完成）买卖双方签合同、中介预约看房



### 主要技术（前后端分离）

- 前端1：house_view_ios
  - Objective-C + Xcode 
  - OC自带的Model + Controller + View 模式
  - 用storyboard + segue实现界面与跳转
  - 全部使用NSURLSession与服务器API通信JSON数据，使用同步信号量实现同步加载
  - 没有使用代理AppDelegate，很多方法是deprecated的。还有很多不完善...
- 前端2：house_view_web
  - JavaScript + JQuery + IntelliJ IDEA + vue.js +Bootstrap 4
  - 使用ajax + JSON与服务器交互数据
  - 仅仅引入了vue.js的头文件（使用了vue.js的调试版本），暂时没有使用vue.js的推荐生产环境结构。DOM操作与vue提供的方法混用，代码可读性低。这一点很不完善...
- 后端：house_system
  - Java 1.8 + IntelliJ IDEA
  - SpringBoot + Maven + MyBatis 快速搭建的微服务
  - Model + Controller模式：model为实体类；controller主要处理请求的接收与发送；service主要处理业务；DAO主要与数据库交互数据；util暂时没有使用
  - （为了方便跨域，）每一个请求发送至后端，都会由interceptor首先拦截，在控制台输出请求方式和URL。
  - 编译运行HouseApplication.java，启动服务器，运行端口：8090。