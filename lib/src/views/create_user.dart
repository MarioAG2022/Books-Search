import 'package:flutter/material.dart';
import 'package:prueba_books/src/controllers/contoller_create_user.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  late ControllerCreateUser _userController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userController = ControllerCreateUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true, // Centra el título
        title: const Text(
          'Crear Usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24, // Aumenta el tamaño del texto
            fontWeight:
                FontWeight.bold, // Opcional: agrega negrita para mayor énfasis
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _userController.nameController,
                label: 'Nombre',
                icon: Icons.person,
                validator: _userController.validateName,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _userController.lastNameController,
                label: 'Apellidos',
                icon: Icons.person_outline,
                validator: _userController.validateLastName,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _userController.phoneController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _userController.validatePhone,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _userController.emailController,
                label: 'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _userController.validateEmail,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _userController.birthDateController,
                label: 'Fecha de Nacimiento',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  await _userController.selectBirthDate();
                  setState(() {}); // Actualiza la edad en la interfaz
                },
              ),
              const SizedBox(height: 8.0),
              Text('Edad: ${_userController.age} años',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _userController.gender,
                hint: const Text('Género'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: ['Masculino', 'Femenino', 'Otro']
                    .map((String gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _userController.gender = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor selecciona un género' : null,
              ),
              const Spacer(),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: ElevatedButton(
              //     onPressed: () => _userController.saveUser(_formKey),
              //     child: Text('Guardar Usuario'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Fondo negro para el BottomAppBar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ElevatedButton(
            onPressed: () => _userController.saveUser(_formKey),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Fondo blanco del botón
              foregroundColor: Colors.black, // Texto en negro
              minimumSize: const Size.fromHeight(50), // Altura del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.all(
                  Colors.blue.withOpacity(0.2)), // Color azul al presionar
            ),
            child: const Text(
              'Guardar Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    void Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onTap: onTap,
      validator: validator,
    );
  }
}
