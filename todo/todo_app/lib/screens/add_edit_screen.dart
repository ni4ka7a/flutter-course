import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/models/todo_item.dart';

class AddEditScreen extends StatefulWidget {
  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  TextEditingController _titleContoller;
  TextEditingController _detailsController;

  @override
  void dispose() {
    _titleContoller.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoBlocState>(
      buildWhen: (prev, curr) => curr.currentItem != prev.currentItem,
      builder: (context, state) {
        final TodoItem item = state.currentItem;

        _titleContoller = TextEditingController(text: item?.title);
        _detailsController = TextEditingController(text: item?.details);

        return Scaffold(
          appBar: AppBar(
            title: Text(item == null ? 'Add Todo' : 'Edit Todo'),
            actions: [
              IconButton(
                icon: Icon(
                  item == null ? Icons.save : Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  final title = _titleContoller.text;
                  final details = _detailsController.text;

                  final todoItem = TodoItem(
                      title: title,
                      details: details,
                      isCompleted: item?.isCompleted,
                      id: item?.id);

                  if (item == null) {
                    BlocProvider.of<TodoBloc>(context).addItem(todoItem);
                  } else {
                    BlocProvider.of<TodoBloc>(context).editItem(todoItem);
                  }

                  Navigator.of(context).pop(todoItem);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              TextField(
                controller: _titleContoller,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'Details',
                  alignLabelWithHint: true,
                  hintMaxLines: 5,
                ),
                maxLines: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
