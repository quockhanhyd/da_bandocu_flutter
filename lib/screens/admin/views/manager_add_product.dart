import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/admin/views/components/product_form.dart';

import '../../auth/views/components/login_form.dart';

class ManagerAddProduct extends StatefulWidget {
  const ManagerAddProduct({super.key});

  @override
  State<ManagerAddProduct> createState() => _ManagerAddProductState();
}

class _ManagerAddProductState extends State<ManagerAddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thêm mới sản phẩm",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text(
                    "Hãy điền thông tin của sản phẩm",
                  ),
                  const SizedBox(height: defaultPadding),
                  AddProductForm(formKey: _formKey),
                  SizedBox(
                    height: size.height > 700
                        ? size.height * 0.1
                        : defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadious / 2),
                      ),
                      child: Container(
                        color: Colors.blue,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  // entryPointScreenRoute,
                                  managerEntryPointScreenRoute,
                                  ModalRoute.withName(managerAddProductRoute));
                            }
                          },
                          child: const Text("Lưu", style: TextStyle(color: Colors.white),),
                        )
                      )
                    ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Đóng"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
