import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/models/filter_popup_item.dart';
import 'package:todo_app/models/options_popup_item.dart';
import 'package:todo_app/screens/add_edit_screen.dart';
import 'package:todo_app/widgets/stats.dart';
import 'package:todo_app/widgets/todo_items_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todos',
        home: MyHomePage(
          title: 'Flutter Todos',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.filter_list),
            ),
            onSelected: (type) {
              switch (type) {
                case FilterPopupItem.all:
                  BlocProvider.of<TodoBloc>(context)
                      .filter(FilterPopupItem.all);
                  break;
                case FilterPopupItem.active:
                  BlocProvider.of<TodoBloc>(context)
                      .filter(FilterPopupItem.active);
                  break;
                case FilterPopupItem.completed:
                  BlocProvider.of<TodoBloc>(context)
                      .filter(FilterPopupItem.completed);
                  break;
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem<FilterPopupItem>(
                  value: FilterPopupItem.all,
                  child: Text('Show all'),
                ),
                PopupMenuItem<FilterPopupItem>(
                  value: FilterPopupItem.active,
                  child: Text('Show active'),
                ),
                PopupMenuItem<FilterPopupItem>(
                  value: FilterPopupItem.completed,
                  child: Text('Show completed'),
                ),
              ];
            },
          ),
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.more_horiz),
            ),
            onSelected: (value) => BlocProvider.of<TodoBloc>(context)
                .markItems(value != OptionsPopupItem.markAllActive),
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem<OptionsPopupItem>(
                  value: OptionsPopupItem.markAllActive,
                  child: Text('Mark all active'),
                ),
                PopupMenuItem<OptionsPopupItem>(
                  value: OptionsPopupItem.markAllCompleted,
                  child: Text('Mark all completed'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _currentSelectedIndex == 0 ? TodoItemsList() : Stats(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditScreen(),
            ),
          );

          BlocProvider.of<TodoBloc>(context).beginAdd();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
        onTap: (index) {
          _currentSelectedIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.data_usage,
            ),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
