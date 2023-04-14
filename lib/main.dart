import 'package:svp/tool.dart';

main(List<String> args) {
  List out = tool(args);
  out.forEach((element) {
    print(element);
  });
}
