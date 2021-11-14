import 'package:flutter/material.dart';
import 'package:habit_tracker_flutter/constants/app_assets.dart';
import 'package:habit_tracker_flutter/ui/common_widgets/centered_svg_icon.dart';
import 'package:habit_tracker_flutter/ui/task/task_completion_ring.dart';
import 'package:habit_tracker_flutter/ui/theming/app_theme.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask({Key? key, required this.iconName}) : super(key: key);
  final String iconName;
  @override
  _AnimatedTaskState createState() => _AnimatedTaskState();
}

class _AnimatedTaskState extends State<AnimatedTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animationController.addStatusListener(_checkStatusUpdate);
    _curveAnimation =
        _animationController.drive(CurveTween(curve: Curves.easeInOut));
  }

  void _checkStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (mounted) {
        setState(() {
          _showCheckIcon = true;
        });
      }
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) setState(() => _showCheckIcon = false);
      });
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_checkStatusUpdate);
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_animationController.isCompleted) {
      _animationController.forward();
    } else if (!_showCheckIcon) {
      _animationController.value = 0;
    }
  }

  void _handleTapCancel() {
    if (_animationController.isCompleted) {
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (BuildContext context, Widget? child) {
          final progress = _curveAnimation.value;
          final hasCompleted = progress == 1.0;
          final themeData = AppTheme.of(context);
          final iconColor =
              hasCompleted ? themeData.accentNegative : themeData.taskIcon;
          return Stack(
            children: [
              TaskCompletionRing(progress: progress),
              Positioned.fill(
                  child: CenteredSvgIcon(
                      iconName: hasCompleted && _showCheckIcon
                          ? AppAssets.check
                          : widget.iconName,
                      color: iconColor))
            ],
          );
        },
      ),
    );
  }
}
