import 'package:glados/glados.dart';
import 'package:test/test.dart';
import 'package:svp/tool.dart';

void main() {
  TestList testList = TestList(); //テスト用のinputと期待されるoutputを生成するインスタンス
  bool addPreRelease; //trueの場合にコアバージョンにプレリリース識別子を追加します
  bool addBuild; //trueの場合にコアバージョンにビルド識別子を追加します
  String
      command; //"same":同じ識別子を追加します。""different":異なる識別子を追加します。""half"：識別子ありとなしを混在させます

  group("要件１：引数に複数の文字列を受け取る)", () {
    test("入力する引数が無い場合", () {
      List<String?> list = [];
      expect(tool(list), equals(["引数を入力してください"]));
    });
    test("入力する引数が１つの場合", () {
      var list = ['1.2.3'];
      expect(tool(list).length, equals(list.length));
    });

    test("入力する引数が２つの場合", () {
      var list = ['1.2.3', '2.4.5'];
      expect(tool(list).length, equals(list.length));
    });

    test("入力する引数が3つの場合", () {
      var list = ['1.2.3', '2.4.5', '5.2.1'];
      expect(tool(list).length, equals(list.length));
    });
  });

  group("要件2：受け取った文字列を新しい順に表示する", () {
    group("プレリリースもビルドも無い場合", () {
      testList.conductTests();
    });

    group("プレリリースのみある場合", () {
      group("プレリリースが全て同じ場合", () {
        addPreRelease = true;
        addBuild = false;
        command = "same";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });

      group("プレリリースが異なる場合", () {
        addPreRelease = true;
        addBuild = false;
        command = "different";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });

      ///全てのバージョンが異なる場合(exp [1.2.3-alpha, 2.1.2-alpha])
      group("プレリリース有りと無しが混在する場合", () {
        addPreRelease = true;
        addBuild = false;
        command = "half";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });

      ///
    });

    group("ビルドのみある場合", () {
      group("ビルドが全て同じ場合", () {
        addPreRelease = false;
        addBuild = true;
        command = "same";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });

      group("ビルドが異なる場合", () {
        addPreRelease = false;
        addBuild = true;
        command = "different";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });

      group("ビルド有りと無しが混在する場合", () {
        addPreRelease = false;
        addBuild = true;
        command = "half";
        testList.conductTests(
            addPreRelease: addPreRelease, addBuild: addBuild, command: command);
      });
    });

    group("プレリリースとビルドが混在している場合", () {
      addPreRelease = false;
      addBuild = true;
      command = "half";
      testList.conductTests(
          addPreRelease: addPreRelease, addBuild: addBuild, command: command);
    });
  });

  group("要件3：受け取った文字列がそうでなかった場合は無視", () {
    List<String> list = [
      "1",
      "1.2",
      "1.2.3-0123",
      "1.2.3-0123.0123",
      "1.1.2+.123",
      "+invalid",
      "-invalid",
      "-invalid+invalid",
      "-invalid.01",
      "alpha",
      "alpha.beta",
      "alpha.beta.1",
      "alpha.1",
      "alpha+beta",
      "alpha_beta",
      "alpha.",
      "alpha..",
      "beta",
      "1.0.0-alpha_beta",
      "-alpha.",
      "1.0.0-alpha..",
      "1.0.0-alpha..1",
      "1.0.0-alpha...1",
      "1.0.0-alpha....1",
      "1.0.0-alpha.....1",
      "1.0.0-alpha......1",
      "1.0.0-alpha.......1",
      "v1.2.3",
      "1.-2.4",
      "01.1.1",
      "1.01.1",
      "1.1.01",
      "1.2",
      "1.2.3.DEV",
      "1.2-SNAPSHOT",
      "1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788",
      "1.2-RC-SNAPSHOT",
      "-1.0.3-gamma+b7718",
      "+justmeta",
      "9.8.7+meta+meta",
      "9.8.7-whatever+meta+meta",
      "99999999999999999999999.9E99999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12",
    ];

    test("フォーマットに沿った入力がなかった場合", () {
      expect(tool(list), equals(["フォーマットに沿った入力がありませんでした"]));
    });

    list.addAll(["5.6.7", "1.2.3"]);
    test("フォーマットに沿った入力が２つあった場合", () {
      expect(tool(list), equals(["1.2.3", "5.6.7"]));
    });
  });
}

class TestList {
  ///テスト用のバージョン生成用のパラメータ(今後の改善点：ハードコードではなく、自動生成できるようにする)
  List<String> _majorListSamples = [
    "1.0.0",
    "2.0.0",
    "3.0.0",
    "4.1.1",
    "5.1.1",
    "6.1.1"
  ];

  List<String> _minorListSamples = [
    "1.0.0",
    "1.1.0",
    "1.2.0",
    "2.3.1",
    "2.4.1",
    "2.5.1"
  ];

  List<String> _patchListSamples = [
    "3.1.0",
    "3.1.1",
    "3.1.2",
    "4.6.3",
    "4.6.4",
    "4.6.5"
  ];

  List<String> _randomVersionSamples = [
    "1.0.0",
    "2.4.2",
    "2.6.1",
    "3.1.20",
    "3.10.1",
    "6.0.0"
  ];

  List<String> _sameVersionSamples = [
    "7.5.7",
    "7.5.7",
    "7.5.7",
    "7.5.7",
    "7.5.7",
    "7.5.7",
  ];

  List<String> _preReleaseSamples = [
    "alpha",
    "alpha.1",
    "alpha.2",
    "alpha.beta",
    "beta",
    "rc"
  ];

  List<String> _buildSamples = [
    "788",
    "build",
    "build.1",
    "build.1-aef",
    "build.123",
    "build.alpha"
  ];

  ///[addPreRelease]や[addBuild]がtrueの時に[_preReleaseSamples]や[_buildSamples]を[command]に応じて指定した[versionType]に追加して返す
  ///
  ///[_preReleaseSamples]と[_buildSamples]がfalseの場合は[command]に何を入力しても結果は変わりません
  Map<String, List<String>> _createInputAndExpectedSV(
      {String? versionType,
      bool? addPreRelease,
      bool? addBuild,
      String? command}) {
    //入力された[versionType]に応じてどのサンプルをもとにテスト用のリストを生成するか決定する
    List<String> anyList;
    List<String> addedList = [];
    List<String> shuffledList;
    String version;
    int index;
    switch (versionType) {
      case "major":
        anyList = _majorListSamples;
        break;

      case "minor":
        anyList = _minorListSamples;
        break;

      case "patch":
        anyList = _patchListSamples;
        break;

      case "random":
        anyList = _randomVersionSamples;
        break;

      case "same":
        anyList = _sameVersionSamples;
        break;
      default:
        anyList = _majorListSamples;
        break;
    }
    int halfnum = anyList.length ~/ 2;

    for (int i = 0; i < anyList.length; i++) {
      version = anyList[i];

      switch (command) {
        case "same":
          index = 0;
          break;
        case "different":
          index = i;
          break;
        default:
          index = i;
          break;
      }

      if (command == "same" ||
          command == "different" ||
          command == "half" && i <= halfnum) {
        if (addPreRelease != null && addPreRelease) {
          version += "-${_preReleaseSamples[index]}";
        }

        if (addBuild != null && addBuild) {
          version += "+${_buildSamples[index]}";
        }
      }

      addedList.add(version);
    }
    shuffledList = addedList.toList()..shuffle();
    return {"output": addedList, "input": shuffledList};
  }

  void conductTests({bool? addPreRelease, bool? addBuild, String? command}) {
    Map<String, String> testMap = {
      "major": "メジャーバージョンのみ異なる場合",
      "minor": "マイナーバージョンのみ異なる場合",
      "patch": "パッチバージョンのみ異なる場合",
      "random": "各バージョンが全て異なる場合",
      "same": "全て同じバージョンの場合"
    };
    testMap.forEach((key, value) {
      Map<String, List<String>> inputAndOutput = _createInputAndExpectedSV(
          versionType: key,
          addPreRelease: addPreRelease,
          addBuild: addBuild,
          command: command);
      test(value, () {
        expect(
            tool(inputAndOutput["input"]!), equals(inputAndOutput["output"]));
      });
    });
  }
}
