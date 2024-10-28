import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:prueba_books/src/providers/user_providers.dart';
import 'package:prueba_books/src/views/user_details.dart';

import 'base_controller.dart';

class ControllerCreateUser extends BaseController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  int age = 0;
  String? gender;

  ControllerCreateUser(BuildContext context) : super(context);

  // Guardar usuario
  void saveUser(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserData(
        nombre: nameController.text,
        apellidos: lastNameController.text,
        telefono: phoneController.text,
        email: emailController.text,
        fecha: birthDateController.text,
        edad: age,
        genero: gender ?? '',
      );

      Navigator.pushReplacementNamed(context, 'user_details');
    }
  }

  // Seleccionar fecha de nacimiento y calcular edad
  Future<void> selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      age = DateTime.now().year - pickedDate.year;
    }
  }

  // Validaciones
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un nombre';
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Solo se permiten letras';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa apellidos';
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Solo se permiten letras';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un teléfono';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'El teléfono debe tener 10 dígitos';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un correo electrónico';
    } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }
}
