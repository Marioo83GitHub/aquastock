class Tanque {
  int? id;
  String nombre;
  String forma; // 'circular', 'cuadrado', 'rectangular'
  double dimension1; // diámetro, lado, o largo
  double dimension2; // 0 para circular/cuadrado, ancho para rectangular
  double altura;
  String densidad; // 'extensivo', 'semi-intensivo', 'intensivo', 'super-intensivo'
  String pesoFinal; // 'pequena', 'grande'
  int cantidadAlevines;
  double biomasaTotal;
  double densidadPorM2;
  double volumen;
  String fechaCreacion;

  Tanque({
    this.id,
    required this.nombre,
    required this.forma,
    required this.dimension1,
    required this.dimension2,
    required this.altura,
    required this.densidad,
    required this.pesoFinal,
    required this.cantidadAlevines,
    required this.biomasaTotal,
    required this.densidadPorM2,
    required this.volumen,
    required this.fechaCreacion,
  });

  // Convertir a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'forma': forma,
      'dimension1': dimension1,
      'dimension2': dimension2,
      'altura': altura,
      'densidad': densidad,
      'pesoFinal': pesoFinal,
      'cantidadAlevines': cantidadAlevines,
      'biomasaTotal': biomasaTotal,
      'densidadPorM2': densidadPorM2,
      'volumen': volumen,
      'fechaCreacion': fechaCreacion,
    };
  }

  // Crear desde Map (SQLite)
  factory Tanque.fromMap(Map<String, dynamic> map) {
    return Tanque(
      id: map['id'],
      nombre: map['nombre'],
      forma: map['forma'],
      dimension1: map['dimension1'],
      dimension2: map['dimension2'],
      altura: map['altura'],
      densidad: map['densidad'],
      pesoFinal: map['pesoFinal'],
      cantidadAlevines: map['cantidadAlevines'],
      biomasaTotal: map['biomasaTotal'],
      densidadPorM2: map['densidadPorM2'],
      volumen: map['volumen'],
      fechaCreacion: map['fechaCreacion'],
    );
  }

  // Helpers para UI
  String get formaTexto {
    switch (forma) {
      case 'circular':
        return 'Circular';
      case 'cuadrado':
        return 'Cuadrado';
      case 'rectangular':
        return 'Rectangular';
      default:
        return forma;
    }
  }

  String get densidadTexto {
    switch (densidad) {
      case 'extensivo':
        return 'Extensivo';
      case 'semi-intensivo':
        return 'Semi-Intensivo';
      case 'intensivo':
        return 'Intensivo';
      case 'super-intensivo':
        return 'Super-Intensivo';
      default:
        return densidad;
    }
  }

  String get pesoFinalTexto {
    return pesoFinal == 'pequena' ? 'Pequeña (150-200g)' : 'Grande (500-800g)';
  }
}