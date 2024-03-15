import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card.dart';
import 'package:apidash/screens/intro_page.dart';
import 'package:apidash/screens/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/collection_providers.dart';
import '../home_page/collection_pane.dart';
import '../home_page/editor_pane/editor_default.dart';
class MobileHome extends ConsumerStatefulWidget {
  const MobileHome(
      { super.key});
  

  @override
  ConsumerState<MobileHome> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openDrawer();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var selectedId = ref.watch(selectedIdStateProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                    Icons.auto_awesome_mosaic_outlined
                ),
            );
          }
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  const MobileDashboard(
                          page: IntroPage(),
                          title: 'Into Page'
                      ),
                    ),
                        );
              },
              icon: const Icon(
                  Icons.help
              )
          ),
          IconButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  const MobileDashboard(
                        page: SettingsPage(),
                        title: 'Settings'
                    ),
                  ),
                );
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                    Icons.settings
                ),
              )
          )
        ],

      ),
      drawer: const Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: kTabHeight),
          child: CollectionPane(),
        ),
      ),
      body: selectedId == null ?
      const Padding(
        padding: kP10,
        child: RequestEditorDefault(),
      ):
      const Column(
        children: [
          SizedBox(
            height: 5,
          ),
          EditorPaneRequestURLCard(),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child:
              EditRequestPane()
          ),
          SendButton(),
          SizedBox(
            height: kHeaderHeight,
          ),
        ],
      ),
    );
  }
}


class MobileDashboard extends StatelessWidget {
  const MobileDashboard({super.key, required this.page, required this.title});
  final Widget page;
  final String title;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
               Expanded(
                  child: page
              ),
            ],
          )
      ),
    );
  }
}
