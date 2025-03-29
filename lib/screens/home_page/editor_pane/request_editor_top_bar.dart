import 'dart:convert';
import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../consts.dart';
import '../../common_widgets/common_widgets.dart';

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
	ref.watch(selectedIdStateProvider);
	final name =
    	ref.watch(selectedRequestModelProvider.select((value) => value?.name));
	return Padding(
  	padding: kP4,
  	child: Row(
    	children: [
      	const APITypeDropdown(),
      	kHSpacer10,
      	Expanded(
        	child: Text(
          	name.isNullOrEmpty() ? kUntitled : name!,
          	style: Theme.of(context).textTheme.bodyMedium,
          	overflow: TextOverflow.ellipsis,
          	maxLines: 1,
        	),
      	),
      	kHSpacer10,
      	EditorTitleActions(
          	onRenamePressed: () {
            	showRenameDialog(context, "Rename Request", name, (val) {
              	ref
                  	.read(collectionStateNotifierProvider.notifier)
                  	.update(name: val);
            	});
          	},
          	onDuplicatePressed: () => ref
              	.read(collectionStateNotifierProvider.notifier)
              	.duplicate(),
          	onDeletePressed: () =>
              	ref.read(collectionStateNotifierProvider.notifier).remove(),
          	onAIEvalPressed: () {
            	showAIEvalDialog(context);
          	}),
      	kHSpacer10,
      	const EnvironmentDropdown(),
    	],
  	),
	);
  }
}

void showAIEvalDialog(BuildContext context) {
  final List<String> datasets = [
	"Hellaswag (Commonsense NLI)",
	"Not Implemented",
	"Not Implemented",
	"Not Implemented",
  ];

  final List<String> implemented_datasets = [
	"Hellaswag (Commonsense NLI)",
  ];

  showDialog(
	context: context,
	builder: (context) {
  	return AlertDialog(
    	title: const Text("AI Eval Selector"),
    	content: Container(
      	padding: const EdgeInsets.all(15),
      	width: 400,
      	child: ListView.builder(
        	itemCount: datasets.length,
        	itemBuilder: (context, index) {
          	final item = datasets[index];
          	return Card(
            	child: ListTile(
              	title: Text(item),
              	onTap: () {
                	if (implemented_datasets.contains(item)) {
                  	Navigator.pop(context);
                  	evalAITestingSuite(context);
                	}
              	},
            	),
          	);
        	},
      	),
    	),
    	actions: <Widget>[
      	TextButton(
        	onPressed: () {
          	Navigator.pop(context);
        	},
        	child: const Text("Close"),
      	),
    	],
  	);
	},
  );
}

void evalAITestingSuite(BuildContext context) {
  final TextEditingController modelText =
  	TextEditingController(text: "davinci-002");
  final TextEditingController urlText =
  	TextEditingController(text: "https://api.openai.com/v1/completions");
  final TextEditingController apiText = TextEditingController();
  final TextEditingController limitText = TextEditingController(text: "20");

  showDialog(
	context: context,
	builder: (context) {
  	return AlertDialog(
    	title: const Text("Run AI Eval - Hellaswag (Commonsence NLI)"),
    	content: SingleChildScrollView(
      	child: Column(
        	mainAxisSize: MainAxisSize.min,
        	children: [
          	TextField(
            	controller: modelText,
            	decoration: const InputDecoration(labelText: "Model"),
          	),
          	TextField(
            	controller: urlText,
            	decoration: const InputDecoration(labelText: "API URL"),
          	),
          	TextField(
            	controller: apiText,
            	decoration: const InputDecoration(labelText: "API Key"),
          	),
          	TextField(
            	controller: limitText,
            	decoration: const InputDecoration(labelText: "Limit"),
          	),
        	],
      	),
    	),
    	actions: [
      	TextButton(
        	onPressed: () => Navigator.pop(context),
        	child: const Text("Close"),
      	),
      	ElevatedButton(
        	onPressed: () async {
          	final model = modelText.text;
          	final url = urlText.text;
          	final apiKey = apiText.text;
          	final limit = int.parse(limitText.text);

          	Navigator.pop(context);

          	showDialog(
            	context: context,
            	builder: (dialogContext) {
              	return AIEvaluationResultDialog(
                	model: model,
                	url: url,
                	apiKey: apiKey,
                	limit: limit,
              	);
            	},
          	);
        	},
        	child: const Text("Run"),
      	),
    	],
  	);
	},
  );
}

class AIEvaluationResultDialog extends StatefulWidget {
  final String model;
  final String url;
  final String apiKey;
  final int limit;

  const AIEvaluationResultDialog({
	super.key,
	required this.model,
	required this.url,
	required this.apiKey,
	required this.limit,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AIEvaluationResultDialogState createState() =>
  	_AIEvaluationResultDialogState();
}

class _AIEvaluationResultDialogState extends State<AIEvaluationResultDialog> {
  String? eval_result;
  bool load = true;

  @override
  void initState() {
	super.initState();
	_runEval();
  }

  Future<void> _runEval() async {
	final result = await Process.run(
  	'python3',
  	[
    	'lib/lm-evaluation-harness/evaluate.py',
    	'--model',
    	widget.model,
    	'--base_url',
    	widget.url,
    	'--api_key',
    	widget.apiKey,
    	'--limit',
    	widget.limit.toString()
  	],
	);

	setState(() {
  	load = false;
  	final output = jsonDecode(result.stdout)["acc"];
  	eval_result = "Hellaswag Accuracy: ${(output * 100).toString()}%";
	});
  }

  @override
  Widget build(BuildContext context) {
	return AlertDialog(
  	content: load
      	? Column(
          	mainAxisSize: MainAxisSize.min,
          	children: [
            	CircularProgressIndicator(),
            	Text('Running AI Eval', textAlign: TextAlign.center),
          	],
        	)
      	: Column(
          	mainAxisSize: MainAxisSize.min,
          	children: [
            	Text('Results'),
            	Text('$eval_result', textAlign: TextAlign.center),
          	],
        	),
  	actions: [
    	TextButton(
      	onPressed: () => Navigator.pop(context),
      	child: const Text('Close'),
    	),
  	],
	);
  }
}
