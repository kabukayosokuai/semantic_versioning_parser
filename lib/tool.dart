List tool(List<String> args) {
  List<String> outputList; //出力時のリスト

  //入力する引数がなかった場合
  if (args.isEmpty) {
    return ["引数を入力してください"];
  } else {
    outputList = args.toList(); //リストのディープコピー
  }

  //入力された引数から有効な文字列のみをフィルタリング
  final except = RegExp(
      r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$');
  outputList = outputList.where((element) => except.hasMatch(element)).toList();
  print("test");

  //フィルタリングしたリストの要素数確認
  if (outputList.isEmpty) {
    return ["フォーマットに沿った入力がありませんでした"];
  }

  //コアバージョンでの並び替え
  final forSplit = RegExp(r'\.|\+|\-');
  int fetchMajorVersion(String sv) => int.parse(sv.split(forSplit)[0]);
  int fetchMinorVersion(String sv) => int.parse(sv.split(forSplit)[1]);
  int fetchPatchVersion(String sv) => int.parse(sv.split(forSplit)[2]);
  int compareMajorFnc(a, b) {
    return fetchMajorVersion(a).compareTo(fetchMajorVersion(b));
  }

  int compareMinorFnc(a, b) {
    return fetchMinorVersion(a).compareTo(fetchMinorVersion(b));
  }

  int comparePatchFnc(a, b) {
    return fetchPatchVersion(a).compareTo(fetchPatchVersion(b));
  }

  outputList.sort();
  //メジャーバージョンでの並び替え
  outputList.sort((a, b) {
    if (fetchMajorVersion(a) != fetchMajorVersion(b)) {
      return compareMajorFnc(a, b);
    }

    if (fetchMinorVersion(a) != fetchMinorVersion(b)) {
      return compareMinorFnc(a, b);
    }

    if (fetchMinorVersion(a) != fetchMinorVersion(b)) {
      return comparePatchFnc(a, b);
    } else {
      int aLength = a.split(forSplit).length;
      int bLength = b.split(forSplit).length;

      if (aLength == 3 && bLength != 3) {
        return b.compareTo(a);
      } else {
        return comparePatchFnc(a, b);
      }
    }
  });

  return outputList;
}

//セマンティックバージョニングの仕様は以下参照
// https://semver.org/lang/ja/
