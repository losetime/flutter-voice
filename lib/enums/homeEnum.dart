List<String> freightSpaceHeader = <String>[
  '仓位',
  '工器具总数量',
  '工器具在位数量',
  '工器具出库数量',
  '仓位状态',
  '放置异常数量'
];

List<String> freightSpaceRowKey = [
  'name',
  'toolExpectSum',
  'toolInSum',
  'toolLeaveSum',
  'status',
  'toolIncorrectSum',
];

List<String> toolHeader = [
  '名称',
  '器具编号',
  '类别',
  '标签',
  '型号',
  '当前仓位',
  '正确仓位',
];

List<String> toolRowKey = [
  'name',
  'codeNumber',
  'toolTypeName',
  'toolTagName',
  'id',
  'currentPosition',
  'expectPosition',
];
