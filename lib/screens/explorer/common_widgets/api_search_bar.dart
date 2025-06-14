import 'package:flutter/material.dart';

class ApiSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const ApiSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  ApiSearchBarState createState() => ApiSearchBarState();
}

class ApiSearchBarState extends State<ApiSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36, // Smaller height
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(18), 
          right: Radius.circular(18),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 16),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(18),
              right: Radius.circular(18),
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
        ),
      ),
    );
  }
}