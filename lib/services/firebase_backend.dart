import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseBackend {
  static bool _initialized = false;
  static String? _initializationError;

  static bool get isReady => _initialized && Firebase.apps.isNotEmpty;
  static String? get initializationError => _initializationError;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.apiKey.startsWith('REPLACE_WITH_')) {
        throw StateError('Les options Firebase doivent être remplacées par celles du projet réel.');
      }

      await Firebase.initializeApp(options: options);
      _initialized = true;
      _initializationError = null;
    } catch (error) {
      _initialized = false;
      _initializationError = error.toString();
    }
  }
}

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  User? get currentUser => FirebaseBackend.isReady ? _auth.currentUser : null;

  Future<String?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    if (!FirebaseBackend.isReady) {
      return "Firebase n'est pas encore configuré pour ce projet.";
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) return "Impossible de créer le compte.";

    final displayName = "$firstName $lastName".trim();
    if (displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
    }

    await _db.collection('users').doc(user.uid).set({
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'name': displayName,
      'email': email.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (!FirebaseBackend.isReady) {
      return "Firebase n'est pas encore configuré pour ce projet.";
    }

    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return null;
  }

  Future<String?> currentUserRole({String fallback = 'Agriculteur'}) async {
    if (!FirebaseBackend.isReady || _auth.currentUser == null) return fallback;

    final snapshot = await _db.collection('users').doc(_auth.currentUser!.uid).get();
    final data = snapshot.data();
    return data?['role'] as String? ?? fallback;
  }

  Stream<Map<String, dynamic>?> watchCurrentUserProfile() {
    if (!FirebaseBackend.isReady || _auth.currentUser == null) {
      return Stream.value(null);
    }

    return _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return {
        ...data,
        'uid': snapshot.id,
        'authEmail': _auth.currentUser?.email,
      };
    });
  }

  Future<void> logout() async {
    if (FirebaseBackend.isReady) {
      await _auth.signOut();
    }
  }
}

class BatchRepository {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Future<void> savePublishedBatch(Map<String, dynamic> batch) async {
    if (!FirebaseBackend.isReady || _auth.currentUser == null) return;

    final id = (batch['id'] as String?)?.replaceAll('#', '') ?? _db.collection('batches').doc().id;
    await _db.collection('batches').doc(id).set({
      ...batch,
      'ownerId': _auth.currentUser!.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> watchPublishedBatches() {
    if (!FirebaseBackend.isReady || _auth.currentUser == null) {
      return const Stream.empty();
    }

    return _db
        .collection('batches')
        .where('ownerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      final batches = snapshot.docs.map((doc) {
        final data = doc.data();
        data['firestoreId'] = doc.id;
        return data;
      }).toList();

      batches.sort((a, b) {
        final aDate = DateTime.tryParse(a['publishDate'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = DateTime.tryParse(b['publishDate'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return batches;
    });
  }
}
