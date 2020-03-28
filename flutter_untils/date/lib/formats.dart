class Formats {

  /// 1993-04-28 05:16:51
  static final List<String> YMD_HMS = ['yyyy', '-', 'mm', '-', 'dd', ' ', 'hh', ':', 'mm', ':', 'ss'];

  /// 1993-04-28
  static final List<String> YMD = ['yyyy', '-', 'mm', '-', 'dd'];

  /// 1993年04月28日
  static final List<String> YMD_CHINESS = ['yyyy', '年', 'mm', '日', 'dd', '日 '];

  /// 05:16:51
  static final List<String> HMS = [ 'hh', ':', 'mm', ':', 'ss'];

  /// 05时16分51秒
  static final List<String> HMS_CHINESS = [  'hh', '时', 'mm', '分', 'ss', '秒'];

  /// 1993年04月28日 05时16分51秒
  static final List<String> YMD_HMS_CHINESS = ['yyyy', '年', 'mm', '日', 'dd', '日 ', 'hh', '时', 'mm', '分', 'ss', '秒'];

   /// 1993年04月28日 05:16:51
  static final List<String> YMD_CHINESS_HMS = ['yyyy', '年', 'mm', '日', 'dd', '日 ', 'hh', ':', 'mm', ':', 'ss'];

}