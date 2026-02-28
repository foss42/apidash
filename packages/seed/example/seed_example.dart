import 'package:seed/seed.dart';

void main() {
  const fdm = FormDataModel(
    name: "harry",
    value: "23",
    type: FormDataType.text,
  );
  print(fdm);

  const nm = NameValueModel(name: "harry", value: 23);
  print(nm);
}
