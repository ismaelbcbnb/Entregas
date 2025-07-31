import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final String title;
  final VoidCallback onEdit, onApprove, onDeliver, onDelete;

  const DataCard({
    required this.title,
    required this.onEdit,
    required this.onApprove,
    required this.onDeliver,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(title),
        subtitle: Wrap(
          spacing: 8,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: Icon(Icons.check), onPressed: onApprove),
            IconButton(icon: Icon(Icons.local_shipping), onPressed: onDeliver),
            IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
