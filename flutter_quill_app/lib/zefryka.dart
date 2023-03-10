import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quill_format/quill_format.dart';
import 'package:zefyrka/zefyrka.dart';

class ZefyrkaEditorPage extends StatefulWidget {
  const ZefyrkaEditorPage({super.key});

  @override
  State<ZefyrkaEditorPage> createState() => _ZefyrkaEditorPageState();
}

class _ZefyrkaEditorPageState extends State<ZefyrkaEditorPage> {
  // Allows to control the editor and the document
  ZefyrController? _controller;

  // Zefyr editor like any other input field requires a focus node.
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = (_controller == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ZefyrEditor(
              controller: _controller!,
              padding: const EdgeInsets.all(16),
              focusNode: _focusNode,
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor page'),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () => _saveDocument(context),
                icon: const Icon(Icons.save)),
          )
        ],
      ),
      body: body,
    );
  }

  /// Loads the document asynchronously from a file if it exists, otherwise
  /// returns default document.
  Future<NotusDocument> _loadDocument() async {
    final file = File('${Directory.systemTemp.path}/quick_start.json');

    if (await file.exists()) {
      final contents = await file.readAsString().then(
          (data) => Future.delayed(const Duration(seconds: 1), () => data));
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final delta = Delta()..insert('Zwfyr Quick Start\n');
    return NotusDocument()..compose(delta, ChangeSource.local);
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller!.document);
    // for this example we save our document to a temporaru file.
    final file = File('${Directory.systemTemp.path}/quick_start.json');
    // And show a snackbar on success
    file.writeAsString(contents).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Document Saved.")));
    });
  }
}
