class ModelTurn {
  /// 获取model原始中的键，没有转化关系
  static List<String> paramsToList(Map<String, dynamic> map){
    List<String> list = [];
    map.keys.forEach((element) {
      list.add(element);
    });
    return list;
  }

  /// 转化Model，获取model中的属性名
  /// 用于key中存在一个_线的属性
  static List<String> paramsConversionToList(Map<String, dynamic> map){
    List<String> list = [];
    map.keys.forEach((element) {
      if (element.contains('_')){
        int index = element.indexOf('_');
        element = element.replaceAll('_', '');
        print(element);
        String subString = element.substring(index, index+1);
        print("subString==$subString");
        subString = subString.toUpperCase();
        List<String> replaceList = element.split('');
        print('replaceList==$replaceList');
        replaceList.replaceRange(index, index+1, [subString]);
        String aaa = replaceList.join('');
        print(aaa);
        list.add(aaa);
      } else {
        list.add(element);
      }
    });
    return list;
  }



  /// 获取Model属性对应的类型，生成用于SQL创建表时使用的参数
  static List<String> paramsTypeToList(Map<String, dynamic> map){
    List<String> list = [];
    map.forEach((key, value) {
      if (value is String){
        list.add('TEXT');
      } else if (value is int || value is double) {
        list.add('REAL');
      } else if (value is bool) {
        list.add('INTEGER');
      }
    });
    return list;
  }
}