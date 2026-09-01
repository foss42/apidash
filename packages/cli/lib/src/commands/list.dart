import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:hive_ce/hive.dart';
import '../storage/storage.dart';
import '../ui/editor.dart';
import 'run.dart';

class ListCommand extends Command {
  final Logger logger;
  ListCommand(this.logger);

  @override final name = "list";
  @override final description = "Lists all saved requests. Features interactive TUI.";

  @override
  void run() async {
    final dataDir = globalResults?['data-dir'] as String;
    final storage = StorageHelper(dataDir, logger);
    
    try {
      await storage.init();
      var requests = await storage.getRequests();

      if (requests.isEmpty) {
        logger.warn("No data found in $dataDir.");
        logger.info("Using mock requests for demonstration...");
        requests = _getMockRequests();
      }

      final choices = requests.map((r) {
        final method = (r['method'] ?? r['httpRequestModel']?['method'] ?? 'GET').toString().toUpperCase().padRight(7);
        return "$method | ${r['name']} [${r['id']}]";
      }).toList();
      
      final choice = logger.chooseOne('Select a request:', choices: choices,);

      var selectedRequest = requests[choices.indexOf(choice)];
      
      bool exitActions = false;
      while (!exitActions) {
        _displayRequest(selectedRequest);

        final action = logger.chooseOne(
          'Select Action:',
          choices: ['Run', 'Edit', 'Curl', 'Back'],
        );

        switch (action) {
          case 'Run':
            await RunCommand(logger).executeRequest(selectedRequest);
            exitActions = true;
            break;
          case 'Edit':
            final editField = logger.chooseOne(
              'What do you want to edit?',
              choices: ['URL', 'Method', 'Params', 'Cancel'],
            );
            
            if (editField == 'URL') {
              final currentUrl = _getHttpField(selectedRequest, 'url') ?? '';
              final newUrl = interactiveEdit('Edit URL', currentUrl);
              _updateRequestField(selectedRequest, 'url', newUrl);
              logger.success('\nURL updated locally.');
            } else if (editField == 'Method') {
              final currentMethod = (_getHttpField(selectedRequest, 'method') ?? 'GET').toString().toUpperCase();
              final newMethod = logger.chooseOne(
                'Select HTTP Method:',
                choices: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD'],
                defaultValue: currentMethod,
              );
              _updateRequestField(selectedRequest, 'method', newMethod);
              logger.success('Method updated locally.');
            } else if (editField == 'Params') {
              await _handleEditParams(selectedRequest);
            }
            break;
          case 'Curl':
            logger.info('Coming soon: Curl generation');
            break;
          case 'Back':
            exitActions = true;
            break;
        }
      }
    } catch (e) {
      logger.err(e.toString());
    } finally {
      await Hive.close();
      await storage.cleanup();
    }
  }

  Future<void> _handleEditParams(Map<String, dynamic> request) async {
    var params = _getHttpField(request, 'params') as List? ?? [];
    var mutableParams = params.map((p) => Map<String, dynamic>.from(p)).toList();

    final paramChoices = mutableParams.map((p) => "${p['name']}: ${p['value']}").toList();
    paramChoices.add('[Add New Parameter]');
    paramChoices.add('[Back]');

    final choice = logger.chooseOne('Select a parameter to edit:', choices: paramChoices);

    if (choice == '[Back]') return;

    if (choice == '[Add New Parameter]') {
      final name = logger.prompt('Parameter Name:');
      final value = logger.prompt('Parameter Value:');
      mutableParams.add({'name': name, 'value': value});
    } else {
      final index = paramChoices.indexOf(choice);
      final p = mutableParams[index];
      final newName = interactiveEdit('Edit Name', p['name'].toString());
      final newValue = interactiveEdit('Edit Value', p['value'].toString());
      mutableParams[index] = {'name': newName, 'value': newValue};
    }

    _updateRequestField(request, 'params', mutableParams);
    logger.success('\nParameters updated locally.');
  }

  dynamic _getHttpField(Map<String, dynamic> request, String field) {
     return request[field] ?? request['httpRequestModel']?[field];
  }

  void _updateRequestField(Map<String, dynamic> request, String field, dynamic value) {
    if (request.containsKey('httpRequestModel')) {
       var model = Map<String, dynamic>.from(request['httpRequestModel']);
       model[field] = value;
       request['httpRequestModel'] = model;
    } else {
       request[field] = value;
    }
  }

  List<Map<String, dynamic>> _getMockRequests() {
    return [
      {
        'id': 'get-1', 
        'name': 'GitHub User Info', 
        'method': 'GET', 
        'url': 'https://api.github.com/users/badnikhil',
        'headers': [{'name': 'User-Agent', 'value': 'Apidash-CLI'}]
      },
      {
        'id': 'get-2', 
        'name': 'HTTPBin Get', 
        'method': 'GET', 
        'url': 'https://httpbin.org/get',
        'params': [{'name': 'foo', 'value': 'bar'}]
      },
    ];
  }

  void _displayRequest(Map<String, dynamic> request) {
    final httpRequest = request['httpRequestModel'] ?? request;
    final method = httpRequest['method'] ?? 'GET';
    final url = httpRequest['url'] ?? 'N/A';
    final params = httpRequest['params'] as List? ?? [];
    
    logger.info('\n--- Request Details ---');
    logger.info('Name:   ${request['name']}');
    logger.info('ID:     ${request['id']}');
    logger.info('Method: ${lightCyan.wrap(method.toString().toUpperCase())}');
    logger.info('URL:    $url');
    if (params.isNotEmpty) {
      logger.info('Params:');
      for (var p in params) {
        logger.info('  - ${p['name']}: ${p['value']}');
      }
    }
    logger.info('-----------------------\n');
  }
}
