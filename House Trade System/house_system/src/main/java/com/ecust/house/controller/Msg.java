package com.ecust.house.controller;


import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
public enum Msg {

    SUCCESS(0, "成功"),
    UsernameOrPwdError(1, "用户名或密码错误"),
    UnLogin(2, "未登录或登录超时"),
    UNKNOWN_CELLPHONE(3, "移动电话不对"),
    CodeException(500, "服务器错误"),
    ParameterError(422, "参数错误"),
    UnSupportRequestMethod(4, "请求方式不支持"),
    SERVER_BUSY(5, "服务器繁忙"),
    UnSafeChar(6, "非法字符"),
    UnAuthorized(7, "未授权"),
    NotExist(8, "数据不存在"),
    NoPermission(9, "无权限"),
    DuplicateError(10, "重复的命名"),
    FileTypeError(11, "文件格式错误"),
    FileTooLarge(12, "文件超过规定大小"),
    FileNone(13, "请选择文件"),
    FileTemplateError(14, "文件模板错误"),
    ExistBussinessProgress(15, "请审批未通过业务"),
    VerificationCodeError(16, "验证码错误"),
    ToManyMobiles(17, "最多发送200个手机号码"),
    MobileError(18, "手机号码应为11位"),
    RequestTypeError(19, "请求方式错误"),
    DataExist(20, "数据已存在");

    @Getter
    private int code;
    @Getter
    private String msg;

}
