import 'dart:io';

import 'package:flutter/services.dart';

class FileReader {
  static FileReader _instance = FileReader._();

  factory FileReader() => _getInstance();

  static FileReader get instance => _getInstance();

  static FileReader _getInstance() {
    return _instance;
  }

  static const MethodChannel _channel = const MethodChannel('wv.io/FileReader');

  FileReader._();

  // Author: qipengxiang
  // Date: 2022-10-08
  //
  // 禁用了原来的自动初始化方法
  // 新增腾讯文档浏览服务手动初始化方法，用来解决小米、华为应用商店的隐私政策审核在用户未授权的情况下读取设备信息
  Future<void> initTencentSmttSdk() async {
    if (Platform.isAndroid) {
      // 仅在Android环境下使用了TencentX5浏览器服务，iOS环境下使用的是系统提供的WKWebView服务所以不需要初始化
      await _channel.invokeMethod('initTencentSmttSdk');
    }
  }

  //X5 engin  load state
  // -1 loading  5 success 10 fail
  void engineLoadStatus(Function(bool)? loadCallback) async {
    _channel.invokeMethod("isLoad").then((status) {
      if (status == 5) {
        loadCallback?.call(true);
      } else if (status == 10) {
        loadCallback?.call(false);
      } else if (status == -1) {
        _channel.setMethodCallHandler((call) async {
          if (call.method == "onLoad") {
            int status = call.arguments;
            if (status == 5) {
              loadCallback?.call(true);
            } else if (status == 10) {
              loadCallback?.call(false);
            }
          }
          return;
        });
      }
    });
  }

  /// open file when platformview create
  /// filepath only support local path
  void openFile(int platformViewId, String filePath, Function(bool)? onOpen) {
    MethodChannel('wv.io/FileReader' + "_$platformViewId").invokeMethod("openFile", filePath).then((openSuccess) {
      onOpen?.call(openSuccess);
    });
  }
}

enum FileReaderState {
  LOADING_ENGINE, //loading engine
  ENGINE_LOAD_SUCCESS, //loading engine success
  ENGINE_LOAD_FAIL, //loading engine fail (only Android ,ios,Ignore)
  UNSUPPORT_FILE, // not support file type
  FILE_NOT_FOUND, //file not found
}
