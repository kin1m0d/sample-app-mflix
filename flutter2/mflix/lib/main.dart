import 'package:flutter/material.dart';
import 'features/movies/movies_list_screen.dart';
import 'features/comments/comments_list_screen.dart';
import 'features/users/users_list_screen.dart';
import 'features/theaters/theaters_list_screen.dart';
import 'features/embedded_movies/embedded_movies_list_screen.dart';
import 'features/sessions/sessions_list_screen.dart';
import 'settings/settings_screen.dart';
import 'features/test/test_list_screen.dart';

void main() {
  runApp(const MFlixApp());
}

class MFlixApp extends StatelessWidget {
  const MFlixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MFlix App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  static const List<Widget> _screens = <Widget>[
    MoviesListScreen(),
    CommentsListScreen(),
    UsersListScreen(),
    TheatersListScreen(),
    EmbeddedMoviesListScreen(),
    SessionsListScreen(),
    TestListScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MFlix App')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.theaters), label: 'Theaters'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter), label: 'Embedded'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.bug_report), label: 'Test'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
