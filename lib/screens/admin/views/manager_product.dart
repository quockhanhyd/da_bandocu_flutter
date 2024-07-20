import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/route/route_constants.dart';

class ManagerProduct extends StatelessWidget {
  const ManagerProduct({super.key});

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }
    
    return SafeArea(child: Scaffold(body: Container(
      color: Colors.yellow,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: [
            Container(
              width: 60,
              height: 40,
              color: Colors.white,
            ),
            const Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Nguyen Van Khanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              Text('Nguyen Dinh Hoang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
            ],)),
            Container(
              width: 20,
              height: 20,
              color: Colors.blue,
            )
          ],),
        ),
      ),
    ),
    bottomSheet: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, managerAddProductRoute);
          },
          child: const Text('Thêm mới'),
        )
      )
    )));
  }
  
}