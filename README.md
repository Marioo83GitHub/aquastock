# 🚀 AquaStock – Sistema de Cálculo de Siembra de Tilapia

**Aplicación móvil desarrollada en Flutter**

AquaStock es una aplicación móvil diseñada para calcular de manera rápida, precisa y automatizada la siembra óptima de tilapia, tomando en cuenta la forma del tanque, sus dimensiones, el sistema de producción y el peso final esperado del pez.

El objetivo principal es apoyar a estudiantes, técnicos y profesionales del área acuícola en la toma de decisiones, reduciendo errores humanos y promoviendo una producción más eficiente y sostenible.

---

## 📘 Características principales

### Inputs del usuario
- Forma del tanque (Circular, Cuadrado, Rectangular)
- Dimensiones según la forma
- Sistema de producción:
  - Extensivo  
  - Semi–intensivo  
  - Intensivo  
  - Super–intensivo
- Peso final esperado:
  - 150–200 g  
  - 500–800 g

### Outputs del sistema
- ✅ Cantidad óptima de alevines  
- ✅ Biomasa total estimada  
- ✅ Densidad por m²  

---

## 🎯 Objetivo del Proyecto
Desarrollar una herramienta fácil de usar que automatice cálculos críticos en acuicultura, evitando errores derivados de operaciones manuales y permitiendo una siembra más segura y eficiente.

---

## 🧪 Funcionalidades de la App

### 📂 Vista 1 — Lista de Tanques Guardados
- Muestra tarjetas con el nombre del tanque y sus resultados principales.  
- Al tocar un tanque, se abre un modal con toda la información detallada (inputs + outputs).  
- Diseño minimalista, limpio y moderno.  

### 📝 Vista 2 — Formulario Interactivo
- Cards seleccionables con borde verde animado.  
- Inputs dinámicos según la forma del tanque.  
- Grid 2×2 para elegir el sistema de producción.  
- Mensaje automático si se elige un método que requiere aireación.  
- Selección del peso final esperado.  
- Botón de “Calcular” que genera los resultados.  

### 📊 Vista 3 — Resultados
- Resumen ordenado de la siembra.  
- Íconos e interfaz minimalista.  
- Botón para volver al inicio y repetir el proceso.  

---

## 🛠️ Tecnologías utilizadas
- Flutter (Dart)  
- Arquitectura basada solo en Widgets  
- Animaciones y transiciones suaves para mayor fluidez  

---

## ▶️ Cómo ejecutar el proyecto

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/Marioo83GitHub/aquastock.git
   cd aquastock
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la app**
   ```bash
   flutter run
   ```

4. **Compilar APK (opcional)**
   ```bash
   flutter build apk --release
   ```
   El APK quedará en:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 👨‍🏫 Caso de uso real
AquaStock fue creado tras observar que en la universidad, cálculos de siembra realizados manualmente provocaron errores críticos que afectaron la producción de tilapia.

La app surge como una solución tecnológica para prevenir sobrepoblación, mortalidad y pérdida de recursos.

---

## 🌱 Impacto esperado
- Reducción de errores en la siembra  
- Mejor aprovechamiento del tanque  
- Producción acuícola más eficiente  
- Menor riesgo de mortalidad por densidad mal calculada  
- Facilita prácticas académicas y laborales  

---

## 🧑‍💻 Autores
**> José Efraín Aguirre Reyes**  
**> Mario Fernando Carbajal Galo**  
**> Ury Roberto Aguirre** 

Estudiantes de Ingeniería en Sistemas  
**UNAH – Choluteca**
