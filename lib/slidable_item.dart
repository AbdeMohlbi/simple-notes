import 'package:flutter/material.dart';

class MyListItem extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final Function(int) onDelete;

  const MyListItem(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.onDelete});

  @override
  MyListItemState createState() => MyListItemState();
}

class MyListItemState extends State<MyListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              ListTile(
                title: Text(widget.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  padding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.comfortable,
                  onPressed: () async {
                    await _animationController.forward();
                    widget.onDelete(widget.id);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
