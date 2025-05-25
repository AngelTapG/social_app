import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    // Colores principales
    surface: Colors.grey.shade300,      // Color de superficie (gris claro)
    primary: Colors.grey.shade500,      // Color primario (gris medio)
    secondary: Colors.grey.shade200,    // Color secundario (gris muy claro)
    tertiary: Colors.grey.shade100,     // Color terciario (gris casi blanco)
    inversePrimary: Colors.grey.shade900, // Color de contraste (gris muy oscuro)
  ),
  scaffoldBackgroundColor: Colors.grey.shade300, // Color de fondo general
);