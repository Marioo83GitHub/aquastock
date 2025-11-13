// Test básico para AquaStock
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora_tilapia/main.dart';

void main() {
  testWidgets('App inicia correctamente', (WidgetTester tester) async {
    // Construye la app
    await tester.pumpWidget(TilapiaApp());

    // Verifica que la pantalla principal se carga
    expect(find.text('Mis Calculadoras'), findsOneWidget);

    // Verifica que el botón flotante existe
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}