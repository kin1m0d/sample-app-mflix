import 'package:flutter/material.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../../services/theaters_api_service.dart';
import 'theaters_list_tab.dart';
import 'theaters_map_tab.dart';


enum TheatersListState { loading, error, loaded }

class TheatersListScreen extends StatefulWidget {
  const TheatersListScreen({super.key});

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> with SingleTickerProviderStateMixin {
  TheatersListState _state = TheatersListState.loading;
  String? _errorMessage;
  List<Map<String, dynamic>> _theaters = [];

  @override
  void initState() {
    super.initState();
    _fetchTheaters();
  }

  Future<void> _fetchTheaters() async {
    setState(() {
      _state = TheatersListState.loading;
      _errorMessage = null;
    });
    try {
      final theaters = await TheatersApiService.fetchTheaters();
      setState(() {
        _theaters = theaters;
        _state = TheatersListState.loaded;
      });
    } catch (e) {
      setState(() {
        _state = TheatersListState.error;
        _errorMessage = 'Failed to load theaters. $e';
      });
    }
  }

  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_state) {
      case TheatersListState.loading:
        content = const LoadingIndicator();
        break;
      case TheatersListState.error:
        content = ErrorMessage(
          message: _errorMessage ?? 'Unknown error',
          onRetry: _fetchTheaters,
        );
        break;
      case TheatersListState.loaded:
        content = Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.map)),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // List tab
                  RefreshIndicator(
                    onRefresh: _fetchTheaters,
                    child: TheatersListTab(theaters: _theaters),
                  ),
                  TheatersMapTab(theaters: _theaters),
                ],
              ),
            ),
          ],
        );
        break;
    }
    return Scaffold(
      body: content,
      floatingActionButton: _state == TheatersListState.loaded
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Theater',
              child: const Icon(Icons.add_business),
            )
          : null,
    );
  }


}
