import 'package:code_builder/code_builder.dart';

Code _toStatement(Spec spec) {
  if (spec is Expression) {
    return spec.statement;
  } else if (spec is Code) {
    return spec;
  } else {
    throw UnimplementedError();
  }
}

Block declareTryCatch({
  required List<Spec> body,
  required Map<String?, List<Spec>> onError,
  bool showStackStrace = false,
}) {
  return Block((b) {
    b.statements.add(const Code('try'));
    b.statements.add(const Code('{'));
    b.statements.addAll(body.map(_toStatement).toList());
    final entries = onError.entries;

    for (var error in entries) {
      b.statements.add(const Code('}'));
      if (error.key != null) {
        b.statements.add(Code('on ${error.key}'));
      }
      b.statements.add(Code(showStackStrace ? 'catch(e,s)' : 'catch(e)'));

      b.statements.add(const Code('{'));
      b.statements.addAll(error.value.map(_toStatement).toList());
      if (entries.last.key == error.key) b.statements.add(const Code('}'));
    }
  });
}

Block declareIfElse({
  required Expression condition,
  required List<Spec> body,
  required List<Spec> elseBody,
}) {
  return Block.of([
    const Code('if('),
    condition.code,
    const Code('){'),
    ...body.map(_toStatement),
    const Code('} else {'),
    ...elseBody.map(_toStatement),
    const Code('}'),
  ]);
}
