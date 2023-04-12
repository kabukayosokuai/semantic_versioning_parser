import 'package:glados/glados.dart';
import 'package:test/test.dart';
import '../tool.dart';

void main() {
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
    ///
  });

  group("要件3：受け取った文字列がそうでなかった場合は無視", () {
    ///引数にString型以外が含まれていた場合(exp int(34.5))
    ///各バージョンの数字にマイナスが含まれていた場合(exp 3.-1.4)
    ///各バージョンの先頭が数字ではなく、文字の場合(exp v2.4.6)
    ///各バージョンの先頭に0が含まれている場合(exp 01.03.06)
  });
}
