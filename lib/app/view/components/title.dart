import 'package:flutter/material.dart';

class TitleH1 extends StatelessWidget {
  const TitleH1(this.title, {super.key, this.color});

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: color),
    );
  }
}

class TextH2 extends StatelessWidget {
  const TextH2(this.title, {super.key, this.color, this.textAlign});

  final String title;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: color,
            height: 1.5,
          ),
      textAlign: textAlign,
    );
  }
}

class TextH3 extends StatelessWidget {
  const TextH3(this.title, {super.key, this.color, this.textAlign});

  final String title;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontSize: 14, fontWeight: FontWeight.w300, color: color),
      textAlign: textAlign,
    );
  }
}
