import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatInputWidget extends StatefulWidget {
  final Function(String text, File? attachedImage) onSend;
  final VoidCallback? onFocus;

  const ChatInputWidget({super.key, required this.onSend, this.onFocus});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _attachedImage;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _attachedImage = File(image.path);
      });
    }
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty && _attachedImage == null) return;
    widget.onSend(_controller.text, _attachedImage);
    _controller.clear();
    setState(() {
      _attachedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_attachedImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Chip(
                label: const Text('Image attached'),
                onDeleted: () => setState(() => _attachedImage = null),
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onTap: widget.onFocus,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
