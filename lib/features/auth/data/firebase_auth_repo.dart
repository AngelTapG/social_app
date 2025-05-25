// Importamos las herramientas necesarias para trabajar con Firebase
import 'package:cloud_firestore/cloud_firestore.dart';  // Para la base de datos
import 'package:firebase_auth/firebase_auth.dart';       // Para la autenticación
import 'package:social_app_jose_gael/features/auth/domain/entities/app_user.dart';  // Nuestro modelo de usuario
import 'package:social_app_jose_gael/features/auth/domain/entities/repos/auth_repo.dart';  // Interfaz que debemos implementar

// Implementación concreta del repositorio de autenticación usando Firebase
class FirebaseAuthRepo implements AuthRepo {
  // Instancias de Firebase que usaremos para todo
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;        // Para manejar usuarios (login, registro, etc.)
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;  // Para guardar datos en la base de datos

  // Método para iniciar sesión con email y contraseña
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Paso 1: Intentamos iniciar sesión con Firebase
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Paso 2: Si el login fue exitoso, buscamos los datos adicionales del usuario en la base de datos
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')                      // Vamos a la colección "users"
          .doc(userCredential.user!.uid)             // Buscamos el documento con el ID del usuario
          .get();                                   // Obtenemos los datos

      // Paso 3: Creamos nuestro objeto de usuario con toda la información
      AppUser user = AppUser(
        uid: userCredential.user!.uid,  // ID único del usuario
        email: email,                   // Email con el que inició sesión
        name: userDoc['name'],          // Nombre que estaba guardado en la base de datos
      );

      // Paso 4: Retornamos el usuario creado
      return user;
    } catch (e) {
      // Si algo falla, lanzamos una excepción con el error
      throw Exception('Login failed: $e');  // Ejemplo: "Login failed: contraseña incorrecta"
    }
  }

  // Método para registrar un nuevo usuario
  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // Paso 1: Creamos el usuario en Firebase Authentication
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Paso 2: Creamos nuestro objeto de usuario
      AppUser user = AppUser(
        uid: userCredential.user!.uid,  // ID que generó Firebase
        email: email,                   // Email que usó para registrarse
        name: name,                     // Nombre que proporcionó
      );

      // Paso 3: Guardamos los datos del usuario en Firestore (base de datos)
      await firebaseFirestore
          .collection("users")         // Colección "users"
          .doc(user.uid)               // Documento con el ID del usuario
          .set(user.toJson());         // Guardamos los datos en formato JSON

      // Paso 4: Retornamos el usuario creado
      return user;
    } catch (e) {
      // Si hay algún error (email ya registrado, etc.)
      throw Exception('Registration failed: $e');
    }
  }

  // Método para cerrar sesión (muy simple)
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();  // Le decimos a Firebase que cierre la sesión
  }

  // Método para obtener el usuario actualmente logueado
  @override
  Future<AppUser?> getCurrentUser() async {
    // Paso 1: Preguntamos a Firebase si hay alguien logueado
    final firebaseUser = firebaseAuth.currentUser;
    
    // Si no hay nadie logueado, retornamos null
    if (firebaseUser == null) {
      return null;
    }

    // Paso 2: Si hay un usuario logueado, buscamos sus datos en Firestore
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();

    // Si no encontramos sus datos en la base de datos, retornamos null
    if (!userDoc.exists) {
      return null;
    }

    // Paso 3: Si todo está bien, creamos y retornamos el objeto de usuario
    return AppUser(
      uid: firebaseUser.uid,       // ID del usuario
      email: firebaseUser.email!,  // Email (el ! significa que estamos seguros que no es null)
      name: userDoc['name'],       // Nombre guardado en Firestore
    );
  }
}