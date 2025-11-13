import 'package:flutter/material.dart';
import '../models/tanque.dart';
import '../database/database_helper.dart';
import '../widgets/selection_card.dart';
import 'results_screen.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Variables del formulario
  String? formaSeleccionada;
  double dimension1 = 0;
  double dimension2 = 0;
  double altura = 0;
  String? densidadSeleccionada;
  String? pesoSeleccionado;

  // Controladores de texto
  final TextEditingController _dimension1Controller = TextEditingController();
  final TextEditingController _dimension2Controller = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  @override
  void dispose() {
    _dimension1Controller.dispose();
    _dimension2Controller.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    setState(() {
      formaSeleccionada = null;
      dimension1 = 0;
      dimension2 = 0;
      altura = 0;
      densidadSeleccionada = null;
      pesoSeleccionado = null;
      _dimension1Controller.clear();
      _dimension2Controller.clear();
      _alturaController.clear();
    });
  }

  bool _validarDimensiones() {
    if (formaSeleccionada == null) return false;
    if (dimension1 <= 0 || altura <= 0) return false;
    if (formaSeleccionada == 'rectangular' && dimension2 <= 0) return false;
    return true;
  }

  double _calcularVolumen() {
    if (formaSeleccionada == 'circular') {
      // V = π × r² × h
      double radio = dimension1 / 2;
      return 3.1416 * radio * radio * altura;
    } else if (formaSeleccionada == 'cuadrado') {
      // V = lado² × h
      return dimension1 * dimension1 * altura;
    } else {
      // V = largo × ancho × h
      return dimension1 * dimension2 * altura;
    }
  }

  double _calcularArea() {
    if (formaSeleccionada == 'circular') {
      double radio = dimension1 / 2;
      return 3.1416 * radio * radio;
    } else if (formaSeleccionada == 'cuadrado') {
      return dimension1 * dimension1;
    } else {
      return dimension1 * dimension2;
    }
  }

  Map<String, dynamic> _calcularResultados() {
    double volumen = _calcularVolumen();
    double area = _calcularArea();

    // Biomasa máxima según densidad (kg/m³)
    double biomasaPorM3;
    switch (densidadSeleccionada) {
      case 'extensivo':
        biomasaPorM3 = 10; // 5-15 kg/m³
        break;
      case 'semi-intensivo':
        biomasaPorM3 = 25; // 20-30 kg/m³
        break;
      case 'intensivo':
        biomasaPorM3 = 60; // 40-80 kg/m³
        break;
      case 'super-intensivo':
        biomasaPorM3 = 100; // 80-150 kg/m³
        break;
      default:
        biomasaPorM3 = 25;
    }

    // Peso por pez (kg)
    double pesoPorPez = pesoSeleccionado == 'pequena' ? 0.175 : 0.65;

    // Cálculos
    double biomasaTotal = volumen * biomasaPorM3;
    int cantidadAlevines = (biomasaTotal / pesoPorPez).round();
    double densidadPorM2 = cantidadAlevines / area;

    return {
      'volumen': volumen,
      'biomasaTotal': biomasaTotal,
      'cantidadAlevines': cantidadAlevines,
      'densidadPorM2': densidadPorM2,
    };
  }

  void _calcularYGuardar() async {
    if (!_validarDimensiones() ||
        densidadSeleccionada == null ||
        pesoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final resultados = _calcularResultados();

    // Crear tanque
    final tanque = Tanque(
      nombre: 'Tanque ${DateTime.now().toString().substring(11, 16)}',
      forma: formaSeleccionada!,
      dimension1: dimension1,
      dimension2: dimension2,
      altura: altura,
      densidad: densidadSeleccionada!,
      pesoFinal: pesoSeleccionado!,
      cantidadAlevines: resultados['cantidadAlevines'],
      biomasaTotal: resultados['biomasaTotal'],
      densidadPorM2: resultados['densidadPorM2'],
      volumen: resultados['volumen'],
      fechaCreacion: DateTime.now().toString(),
    );

    // Guardar en base de datos
    await DatabaseHelper.instance.insertTanque(tanque);

    // Navegar a resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(tanque: tanque),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Tanque'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('¿Cancelar?'),
                content: Text('Se perderán los datos ingresados'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Sí, cancelar'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          // Botón para limpiar el formulario
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Limpiar formulario',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('¿Limpiar formulario?'),
                  content: Text('Se borrarán todos los datos ingresados'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _limpiarFormulario();
                      },
                      child: Text('Limpiar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Paso 1: Forma del tanque
            _buildSectionTitle('1. Forma del tanque'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SelectionCard(
                    title: 'Circular',
                    icon: Icons.circle_outlined,
                    isSelected: formaSeleccionada == 'circular',
                    onTap: () => setState(() => formaSeleccionada = 'circular'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SelectionCard(
                    title: 'Cuadrado',
                    icon: Icons.crop_square,
                    isSelected: formaSeleccionada == 'cuadrado',
                    onTap: () => setState(() => formaSeleccionada = 'cuadrado'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SelectionCard(
                    title: 'Rectangular',
                    icon: Icons.rectangle_outlined,
                    isSelected: formaSeleccionada == 'rectangular',
                    onTap: () => setState(() => formaSeleccionada = 'rectangular'),
                  ),
                ),
              ],
            ),

            // Paso 2: Dimensiones (solo si hay forma seleccionada)
            if (formaSeleccionada != null) ...[
              SizedBox(height: 32),
              _buildSectionTitle('2. Dimensiones del tanque'),
              SizedBox(height: 16),
              if (formaSeleccionada == 'circular') ...[
                _buildTextField(
                  controller: _dimension1Controller,
                  label: 'Diámetro (metros)',
                  icon: Icons.straighten,
                  onChanged: (value) =>
                      setState(() => dimension1 = double.tryParse(value) ?? 0),
                ),
                SizedBox(height: 12),
              ],
              if (formaSeleccionada == 'cuadrado') ...[
                _buildTextField(
                  controller: _dimension1Controller,
                  label: 'Lado (metros)',
                  icon: Icons.straighten,
                  onChanged: (value) =>
                      setState(() => dimension1 = double.tryParse(value) ?? 0),
                ),
                SizedBox(height: 12),
              ],
              if (formaSeleccionada == 'rectangular') ...[
                _buildTextField(
                  controller: _dimension1Controller,
                  label: 'Largo (metros)',
                  icon: Icons.straighten,
                  onChanged: (value) =>
                      setState(() => dimension1 = double.tryParse(value) ?? 0),
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _dimension2Controller,
                  label: 'Ancho (metros)',
                  icon: Icons.straighten,
                  onChanged: (value) =>
                      setState(() => dimension2 = double.tryParse(value) ?? 0),
                ),
                SizedBox(height: 12),
              ],
              _buildTextField(
                controller: _alturaController,
                label: 'Altura (metros)',
                icon: Icons.height,
                onChanged: (value) =>
                    setState(() => altura = double.tryParse(value) ?? 0),
              ),
            ],

            // Paso 3: Densidad (solo si hay dimensiones válidas)
            if (_validarDimensiones()) ...[
              SizedBox(height: 32),
              _buildSectionTitle('3. Sistema de producción'),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0, // Cambiado de 1.2 a 1.0 para más altura
                children: [
                  SelectionCard(
                    title: 'Extensivo',
                    subtitle: '1-3 peces/m²',
                    icon: Icons.water_drop_outlined,
                    isSelected: densidadSeleccionada == 'extensivo',
                    onTap: () =>
                        setState(() => densidadSeleccionada = 'extensivo'),
                  ),
                  SelectionCard(
                    title: 'Semi-Intensivo',
                    subtitle: '4-10 peces/m²',
                    icon: Icons.water,
                    isSelected: densidadSeleccionada == 'semi-intensivo',
                    onTap: () =>
                        setState(() => densidadSeleccionada = 'semi-intensivo'),
                  ),
                  SelectionCard(
                    title: 'Intensivo',
                    subtitle: '10-50 peces/m²',
                    icon: Icons.waves,
                    isSelected: densidadSeleccionada == 'intensivo',
                    onTap: () =>
                        setState(() => densidadSeleccionada = 'intensivo'),
                  ),
                  SelectionCard(
                    title: 'Super-Intensivo',
                    subtitle: '50-100+ peces/m²',
                    icon: Icons.water_damage,
                    isSelected: densidadSeleccionada == 'super-intensivo',
                    onTap: () => setState(
                            () => densidadSeleccionada = 'super-intensivo'),
                  ),
                ],
              ),
              if (densidadSeleccionada == 'intensivo' ||
                  densidadSeleccionada == 'super-intensivo') ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '[!] Se necesita un sistema de aireación para este método de siembra',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            // Paso 4: Peso final (solo si hay densidad seleccionada)
            if (densidadSeleccionada != null) ...[
              SizedBox(height: 32),
              _buildSectionTitle('4. Peso final esperado'),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SelectionCard(
                      title: 'Tilapia Pequeña',
                      subtitle: '150-200g',
                      icon: Icons.set_meal,
                      isSelected: pesoSeleccionado == 'pequena',
                      onTap: () => setState(() => pesoSeleccionado = 'pequena'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SelectionCard(
                      title: 'Tilapia Grande',
                      subtitle: '500-800g',
                      icon: Icons.dinner_dining,
                      isSelected: pesoSeleccionado == 'grande',
                      onTap: () => setState(() => pesoSeleccionado = 'grande'),
                    ),
                  ),
                ],
              ),
            ],

            // Botón calcular
            if (pesoSeleccionado != null) ...[
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _calcularYGuardar,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Calcular',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      onChanged: onChanged,
    );
  }
}