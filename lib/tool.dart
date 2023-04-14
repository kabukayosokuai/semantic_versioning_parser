List tool(List<String> args) {
  List<String> outputList; //出力時のリスト

  //入力する引数がなかった場合
  if (args.isEmpty) {
    return ["引数を入力してください"];
  } else {
    outputList = args.toList(); //リストのディープコピー
  }

  //入力された引数から有効な文字列のみをフィルタリング

  //フィルタリングしたリストの要素数確認
  if (outputList.isEmpty) {
    return ["フォーマットに沿った入力がありませんでした"];
  }

  //並び替え(コアバージョンの並び替えには不適切)
  outputList.sort();

  //コアバージョン毎に[dupCoreVersions]へ格納
  List<String> sortedOutputList = [];
  Map<String, List> dupCoreVersions = {};

  //[dupCoreVersions]の各要素に対して並び替え
  dupCoreVersions.forEach((key, arrs) {
    bool forSort(sv) => sv.length == key.length;
    List<String> sorted = [
      ...arrs.skipWhile(forSort),
      ...arrs.takeWhile(forSort)
    ];
    sortedOutputList.addAll(sorted);
  });

  return outputList;
}

//セマンティックバージョニングの仕様は以下参照
// https://semver.org/lang/ja/
