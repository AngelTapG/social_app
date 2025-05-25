import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    // Colores principales
    surface: Color.fromARGB(255, 9, 9, 9),       // Color de fondo de barras y cajas
    primary: Color.fromARGB(255,105,105,105),    // Color principal (botones importantes)
    secondary: Color.fromARGB(255, 20, 20, 20),  // Color secundario
    tertiary: Color.fromARGB(255, 29, 29, 29),   // Color terciario
    inversePrimary: Color.fromARGB(255, 195, 195, 195), // Color claro para contrastar
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 9, 9, 9), // Color de fondo general
);

