import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    this.hintText = "Search business cards...",
    this.onChanged,
    this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller!.clear();
                  onChanged?.call("");
                  onClear?.call();
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
