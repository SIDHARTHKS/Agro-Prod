import 'package:agro/gen/assets.gen.dart';
import 'package:agro/helper/color_helper.dart';
import 'package:agro/view/widget/common_widget.dart';
import 'package:flutter/material.dart';

class SuccessDialogue extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;

  const SuccessDialogue({
    super.key,
    this.width = 350,
    this.height = 470,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
  });

  @override
  State<SuccessDialogue> createState() => _SuccessDialogueState();
}

class _SuccessDialogueState extends State<SuccessDialogue> {
  @override
  void initState() {
    super.initState();

    // Auto-dismiss after 300ms (safe and non-layout-mutating)
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorHelper().cardColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appText(
                widget.title,
                textAlign: TextAlign.center,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColorHelper().primaryColor,
                height: 1.3,
              ),
              const SizedBox(height: 30),
              Image.asset(
                Assets.icons.success.path,
                scale: 3.7,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appText(
                    widget.subtitle1,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColorHelper().primaryTextColor,
                  ),
                  appText(
                    widget.subtitle2,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColorHelper().primaryColor,
                  ),
                ],
              ),
              appText(
                widget.subtitle3,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColorHelper().primaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
