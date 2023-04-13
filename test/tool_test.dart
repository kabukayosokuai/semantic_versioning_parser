import 'package:glados/glados.dart';
import 'package:test/test.dart';
import '../tool.dart';

void main() {
  CreateTestList prac = CreateTestList();
  Map lists = prac.createInputAndExpectedSV(
      versionType: "major",
      addPreRelease: true,
      addBuild: true,
      command: "half");
  print(lists["input"]);
  print(lists["output"]);

  ///フォーマットに沿った入力を１つ以上入力した場合のテスト
  group("要件１：引数に複数の文字列を受け取る)", () {
    ///入力する引数が無い場合
    test("入力する引数が１つの場合", () {
      var list = ['1.2.3'];
      expect(tool(list), equals(list));
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

  group("要件2：受け取った文字列がSemanticsVersioningのFormatだった場合、Versionが新しい順に表示する", () {
    group("2-1 プレリリースもビルドも無い場合", () {
      ///メジャーバージョンが異なる場合(exp [1.0.0, 2.0.0])
      ///マイナーバージョンが異なる場合(exp [1.2.0, 1.3.0])
      ///パッチバージョンが異なる場合(exp [1.1.3, 1.1.5])
      ///全てのバージョンが異なる場合(exp [1.2.3, 2.1.2])
      ///引数が全て同じ場合
    });

    group("2-2 プレリリースのみある場合", () {
      group("2-2-1 プレリリースが全て同じ場合", () {
        ///メジャーバージョンが異なる場合(exp [1.0.0-alpha, 2.0.0-alpha])
        ///マイナーバージョンが異なる場合(exp [1.2.0-alpha, 1.3.0-alpha])
        ///パッチバージョンが異なる場合(exp [1.1.3-alpha, 1.1.5-alpha])
        ///全てのバージョンが異なる場合(exp [1.2.3-alpha, 2.1.2-alpha])
      });

      group("2-2-2 プレリリースが異なる場合", () {});

      ///全てのバージョンが異なる場合(exp [1.2.3-alpha, 2.1.2-alpha])
      group("2-2-3プレリリース有りと無しが混在する場合", () {});

      ///
    });

    group("2-3 ビルドのみある場合", () {
      group("2-3-1 ビルドが全て同じ場合", () {
        ///メジャーバージョンが異なる場合(exp [1.0.0-alpha, 2.0.0-alpha])
        ///マイナーバージョンが異なる場合(exp [1.2.0-alpha, 1.3.0-alpha])
        ///パッチバージョンが異なる場合(exp [1.1.3-alpha, 1.1.5-alpha])
        ///全てのバージョンが異なる場合(exp [1.2.3-alpha, 2.1.2-alpha])
      });

      group("2-3-2ビルドが異なる場合", () {});

      group("2-3-3 ビルド有りと無しが混在する場合", () {});
    });

    group("2-4 プレリリースとビルドが混在している場合", () {});
  });

  group("要件3：受け取った文字列がそうでなかった場合は無視", () {
    ///入力した文字列にフォーマットに沿った入力がなかった場合に""フォーマットに沿った入力はありませんでした"と返す
    ///引数にString型以外が含まれていた場合(exp int(34.5))
    ///各バージョンの数字にマイナスが含まれていた場合(exp 3.-1.4)
    ///各バージョンの先頭が数字ではなく、文字の場合(exp v2.4.6)
    ///各バージョンの先頭に0が含まれている場合(exp 01.03.06)
  });
}

class CreateTestList {
  ///テスト用のバージョンコア配列(予測値)
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
    "3.10.1",
    "3.1.20",
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
  Map<String, List<String>> createInputAndExpectedSV(
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
    return {"input": addedList, "output": shuffledList};
  }
}
