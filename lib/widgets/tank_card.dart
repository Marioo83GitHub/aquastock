import 'package:flutter/material.dart';
import '../models/tanque.dart';

class TankCard extends StatelessWidget {
  final Tanque tanque;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TankCard({
    Key? key,
    required this.tanque,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y botón eliminar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tanque.nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                    onPressed: onDelete,
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Outputs principales
              _buildInfoRow(
                Icons.water_drop,
                'Cantidad de alevines',
                '${tanque.cantidadAlevines} peces',
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.scale,
                'Biomasa total',
                '${tanque.biomasaTotal.toStringAsFixed(1)} kg',
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.grid_4x4,
                'Densidad',
                '${tanque.densidadPorM2.toStringAsFixed(1)} peces/m²',
              ),
              SizedBox(height: 12),
              // Indicador de tap para ver más
              Center(
                child: Text(
                  'Toca para ver detalles',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green.shade600),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
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
    );
  }
}