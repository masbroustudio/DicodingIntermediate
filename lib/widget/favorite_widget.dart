import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  Icon getFavoriteIcon() {
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      color: isFavorite ? Colors.red : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: getFavoriteIcon(),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
