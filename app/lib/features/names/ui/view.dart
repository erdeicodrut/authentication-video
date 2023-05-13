import 'package:auth_app/features/names/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final namesBloc = BlocProvider.of<NamesBloc>(context);

    // Fetch names on screen initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      namesBloc.add(FetchNamesEvent());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Names'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          namesBloc.add(FetchNamesEvent());
        },
        child: BlocBuilder<NamesBloc, NamesState>(
          builder: (context, state) {
            if (state is NamesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NamesLoaded) {
              final names = state.names;
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(names[index]),
                  );
                },
              );
            } else if (state is NamesError) {
              return Center(
                child: Text(
                  state.error,
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Name'),
                content: TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onSubmitted: (value) {
                    namesBloc.add(AddNameEvent(value));
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
