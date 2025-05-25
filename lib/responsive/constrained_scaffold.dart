/*
  SCAFFOLD CON ANCHO LIMITADO

  Esta es una versión modificada del Scaffold normal que limita el ancho máximo,
  para que la aplicación se vea consistente en pantallas grandes (especialmente
  en navegadores web).
*/

import 'package:flutter/material.dart'; // Importamos los widgets básicos de Flutter

class ConstrainedScaffold extends StatelessWidget {
  // Parámetros que podemos personalizar al usar este widget:
  final Widget body;    // El contenido principal de la pantalla
  final PreferredSizeWidget? appBar;  // La barra superior (opcional)
  final Widget? drawer; // El menú lateral (opcional)

  // Constructor - las llaves {} hacen que los parámetros sean opcionales (excepto 'body')
  const ConstrainedScaffold({
    super.key,
    required this.body,  // 'required' indica que el parámetro es obligatorio
    this.appBar,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,   // Usamos la appBar (o null si no hay)
      drawer: drawer,   // Igual con el drawer (menú lateral)
      body: Center(     // Centramos todo el contenido
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430 // Límite máximo de ancho (píxeles)
          ),
          child: body,  // Aquí va el contenido principal
        ),
      ),
    );
  }
}