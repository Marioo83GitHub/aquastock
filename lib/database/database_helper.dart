import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tanque.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _tanquesKey = 'tanques_list';

  DatabaseHelper._init();

  // Obtener SharedPreferences
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // Insertar tanque
  Future<int> insertTanque(Tanque tanque) async {
    final prefs = await _prefs;
    
    // Obtener lista actual
    List<Tanque> tanques = await getAllTanques();
    
    // Generar ID (último ID + 1)
    int newId = tanques.isEmpty ? 1 : (tanques.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    tanque.id = newId;
    
    // Agregar nuevo tanque
    tanques.add(tanque);
    
    // Guardar en SharedPreferences
    List<String> tanquesJson = tanques.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_tanquesKey, tanquesJson);
    
    return newId;
  }

  // Obtener todos los tanques
  Future<List<Tanque>> getAllTanques() async {
    final prefs = await _prefs;
    
    List<String>? tanquesJson = prefs.getStringList(_tanquesKey);
    
    if (tanquesJson == null || tanquesJson.isEmpty) {
      return [];
    }
    
    return tanquesJson.map((jsonStr) {
      Map<String, dynamic> map = jsonDecode(jsonStr);
      return Tanque.fromMap(map);
    }).toList();
  }

  // Obtener tanque por ID
  Future<Tanque?> getTanque(int id) async {
    List<Tanque> tanques = await getAllTanques();
    try {
      return tanques.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Eliminar tanque
  Future<int> deleteTanque(int id) async {
    final prefs = await _prefs;
    
    List<Tanque> tanques = await getAllTanques();
    tanques.removeWhere((t) => t.id == id);
    
    List<String> tanquesJson = tanques.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_tanquesKey, tanquesJson);
    
    return 1;
  }

  // Cerrar (no hace nada en SharedPreferences pero mantiene compatibilidad)
  Future close() async {
    // No se necesita cerrar SharedPreferences
  }
}