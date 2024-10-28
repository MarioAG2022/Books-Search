import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_books/src/providers/user_providers.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true, // Centra el título
        title: const Text(
          'Detalles del Usuario',
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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailItem(
                icon: Icons.person,
                label: 'Nombre',
                value: userProvider.nombre,
              ),
              _buildDetailItem(
                icon: Icons.person_outline,
                label: 'Apellidos',
                value: userProvider.apellidos,
              ),
              _buildDetailItem(
                icon: Icons.phone,
                label: 'Teléfono',
                value: userProvider.telefono,
              ),
              _buildDetailItem(
                icon: Icons.email,
                label: 'Correo Electrónico',
                value: userProvider.email,
              ),
              _buildDetailItem(
                icon: Icons.cake,
                label: 'Fecha de Nacimiento',
                value: userProvider.fecha,
              ),
              _buildDetailItem(
                icon: Icons.calendar_today,
                label: 'Edad',
                value: '${userProvider.edad} años',
              ),
              _buildDetailItem(
                icon: Icons.wc,
                label: 'Género',
                value: userProvider.genero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
