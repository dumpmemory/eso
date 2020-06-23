export 'global.dart';

import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

export 'package:cached_network_image/cached_network_image.dart';

/// 事件bus
EventBus eventBus = EventBus();

class Utils {

  static bool empty(String value) {
    return value == null || value.isEmpty;
  }

  /// 延时指定毫秒
  static sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// 清除输入焦点
  static unFocus(BuildContext context) {
    var f = FocusScope.of(context);
    if (f != null && f.hasFocus)
      f.unfocus(disposition: UnfocusDisposition.scope);
  }


  /// 开始一个页面，并等待结束
  static Future<Object> startPageWait(BuildContext context, Widget page) async {
    if (page == null) return null;
    var rote = Platform.isIOS ? CupertinoPageRoute(builder: (context) => page) :
      MaterialPageRoute(builder: (_) => page);
    return await Navigator.push(context, rote);
  }

  static String _downloadPath;

  /// 提取文件名（不包含路径和扩展名）
  static String getFileName(final String file) {
    return path.basenameWithoutExtension(file);
  }

  /// 检测路径是否存在
  static bool existPath(final String _path) {
    return Directory(_path).existsSync();
  }

  /// 获取下载目录
  static Future<String> getDownloadsPath() async {
    if (Platform.isIOS)
      return (await getApplicationDocumentsDirectory()).path;
    else {
      if (_downloadPath == null) {
        _downloadPath = (await getExternalStorageDirectory()).path;
        if (!(existPath(_downloadPath)))
          _downloadPath = (await getTemporaryDirectory()).path;
      }
      print("downloadPath: $_downloadPath");
      return _downloadPath;
    }
  }
}