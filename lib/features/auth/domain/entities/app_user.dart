// Clase que representa a un usuario de la aplicación
class AppUser {
  // Propiedades finales (inmutables) del usuario
  final String uid;    // ID único del usuario en Firebase
  final String email;  // Correo electrónico del usuario
  final String name;   // Nombre del usuario

  // Constructor con parámetros requeridos
  AppUser({
    required this.uid,    // Se exige proporcionar un UID
    required this.email,  // Se exige proporcionar un email
    required this.name    // Se exige proporcionar un nombre
  });

  // Método para convertir el objeto AppUser a un Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,     // Mapea uid a campo 'uid'
      'email': email, // Mapea email a campo 'email'
      'name': name,   // Mapea name a campo 'name'
    };
  }

  // Factory constructor para crear un AppUser desde un Map/JSON
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],    // Extrae uid del JSON
      email: jsonUser['email'],// Extrae email del JSON
      name: jsonUser['name'],  // Extrae name del JSON
    );
  }
}