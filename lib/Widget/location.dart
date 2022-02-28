import 'package:flutter/material.dart';
class LocationWidget extends StatefulWidget {

  final bool startDrag;
  const LocationWidget({Key? key,
  required this.startDrag}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> valueAnim;

  @override
  void initState() {
    super.initState();
  controller=  AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  valueAnim =Tween<double>(begin: -5,end: 5).animate(CurvedAnimation(
      parent: controller, curve: Curves.easeIn));


  }




  @override
  Widget build(BuildContext context) {
    conditionAnimation();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Transform.translate(
            offset: Offset(0.0, valueAnim.value),
            child: const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 45,
            ),
          ),
        ),
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(bottom: 38),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        )
      ],
    );
  }
  void conditionAnimation()
  {
    if(widget.startDrag)
    {
      controller.repeat();
    }else {
      controller.reverse();
    }
  }
}
