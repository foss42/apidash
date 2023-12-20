import 'package:code_builder/code_builder.dart';

Block declareTryCatch({
  required List<Expression> body,
  required Map<String?, List<Expression>> onError,
  bool showStackStrace = false,
}) {
  return Block((b) {
    b.statements.add(const Code('try'));
    b.statements.add(const Code('{'));
    b.statements.addAll(body.map((e) => e.statement).toList());
    final entries = onError.entries;

    for (var error in entries) {
      b.statements.add(const Code('}'));
      if (error.key != null) {
        b.statements.add(Code('on ${error.key}'));
      }
      b.statements.add(Code(showStackStrace ? 'catch(e,s)' : 'catch(e)'));

      b.statements.add(const Code('{'));
      b.statements.addAll(error.value.map((e) => e.statement).toList());
      if (entries.last.key == error.key) b.statements.add(const Code('}'));
    }
  });
}
