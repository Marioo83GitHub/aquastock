import 'package:flutter/material.dart';
import '../models/tanque.dart';
import '../database/database_helper.dart';
import '../widgets/tank_card.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Tanque> tanques = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTanques();
  }

  Future<void> _loadTanques() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.getAllTanques();
    setState(() {
      tanques = data;
      isLoading = false;
    });
  }

  Future<void> _deleteTanque(int id) async {
    await DatabaseHelper.instance.deleteTanque(id);
    _loadTanques();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tanque eliminado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDetailsModal(Tanque tanque) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header del modal
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                tanque.nombre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 20),
              _buildDetailSection('Configuración del Tanque', [
                _buildDetailRow('Forma', tanque.formaTexto, Icons.category),
                _buildDetailRow(
                  'Dimensiones',
                  _getDimensionsText(tanque),
                  Icons.straighten,
                ),
                _buildDetailRow(
                  'Altura',
                  '${tanque.altura.toStringAsFixed(2)} m',
                  Icons.height,
                ),
                _buildDetailRow(
                  'Volumen',
                  '${tanque.volumen.toStringAsFixed(2)} m³',
                  Icons.water,
                ),
              ]),
              SizedBox(height: 20),
              _buildDetailSection('Sistema de Producción', [
                _buildDetailRow(
                  'Densidad',
                  tanque.densidadTexto,
                  Icons.density_medium,
                ),
                _buildDetailRow(
                  'Peso final',
                  tanque.pesoFinalTexto,
                  Icons.monitor_weight,
                ),
              ]),
              SizedBox(height: 20),
              _buildDetailSection('Resultados', [
                _buildDetailRow(
                  'Alevines',
                  '${tanque.cantidadAlevines} peces',
                  Icons.water_drop,
                ),
                _buildDetailRow(
                  'Biomasa',
                  '${tanque.biomasaTotal.toStringAsFixed(1)} kg',
                  Icons.scale,
                ),
                _buildDetailRow(
                  'Densidad/m²',
                  '${tanque.densidadPorM2.toStringAsFixed(1)} peces/m²',
                  Icons.grid_4x4,
                ),
              ]),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDimensionsText(Tanque tanque) {
    if (tanque.forma == 'circular') {
      return 'Ø ${tanque.dimension1.toStringAsFixed(2)} m';
    } else if (tanque.forma == 'cuadrado') {
      return '${tanque.dimension1.toStringAsFixed(2)} m';
    } else {
      return '${tanque.dimension1.toStringAsFixed(2)} x ${tanque.dimension2.toStringAsFixed(2)} m';
    }
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tanques'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tanques.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_damage_outlined,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No hay tanques registrados',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Margen a ambos lados
                        child: Text(
                          'Presiona el ícono de Calculadora para agregar un Tanque.',
                          textAlign: TextAlign.center, // Centra el texto
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: tanques.length,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final tanque = tanques[index];
                    return TankCard(
                      tanque: tanque,
                      onTap: () => _showDetailsModal(tanque),
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Eliminar tanque'),
                            content: Text(
                              '¿Estás seguro de eliminar "${tanque.nombre}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteTanque(tanque.id!);
                                },
                                child: Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          );
          if (result == true) {
            _loadTanques();
          }
        },
        child: Icon(Icons.calculate),
        tooltip: 'Nueva calculadora',
      ),
    );
  }
}