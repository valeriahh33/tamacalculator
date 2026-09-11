# TAMA-CALC 🐱

Calculadora Flutter desarrollada como extensión del ejercicio base de la sumadora entregado por el profesor.

## Funcionalidades

- Suma y resta.
- Multiplicación.
- División normal.
- Cociente entero.
- Residuo.
- Potenciación general y acceso rápido a x².
- Radicación cuadrada.
- Logaritmo base 10.
- Validación de par/impar para dos números.
- Manejo de división entre cero, raíz negativa, logaritmos inválidos y entradas incorrectas.
- Splash animado.
- Diseño responsive para celular.

## Arquitectura: Layers First

La organización principal de `lib` está hecha por **capas**, no por funcionalidades. Primero aparecen las capas y dentro de ellas sus responsabilidades:

```text
lib/
├── main.dart
└── layers/
    ├── core/
    │   └── theme/
    │       └── app_theme.dart
    ├── domain/
    │   ├── entities/
    │   │   └── calculation_result.dart
    │   └── services/
    │       └── calculator_service.dart
    └── presentation/
        ├── controllers/
        │   └── calculator_controller.dart
        ├── screens/
        │   ├── splash/
        │   │   └── splash_screen.dart
        │   └── calculator/
        │       └── calculator_screen.dart
        └── widgets/
            ├── cat_display.dart
            └── pixel_button.dart

assets/
└── images/
    ├── gato.png
    └── fondo_gato.png
```

### Por qué Layers First

- **core:** elementos transversales, como colores y tema.
- **domain:** reglas del negocio y lógica matemática; no depende de Flutter para calcular.
- **presentation:** interfaz, estado y componentes visuales.
- La pantalla no contiene la matemática: solicita operaciones al controller y el controller utiliza `CalculatorService`.
- Esto permite modificar el diseño sin alterar la lógica y ampliar operaciones sin convertir `main.dart` en un archivo gigante.

## Relación con el código del profesor

`main_base_profesor.dart` conserva el archivo original entregado en clase como referencia. En ese archivo la sumadora tenía dos campos, una variable de resultado y un método `sumar()`. La extensión conserva el concepto de recibir números y calcular, pero separa las responsabilidades en capas.

## Cómo ejecutar

```bash
flutter pub get
flutter analyze
flutter run
```

## Lógica de par/impar

Ejemplo: `8` → `+` → `5` → `PAR/IMPAR` produce `N1: PAR | N2: IMPAR`.

El servicio exige números enteros para esta validación porque par/impar es una propiedad de enteros.

## Guion breve para el video

1. **Funcionamiento:** mostrar splash, ingresar números y probar cada operación.
2. **Lógica:** explicar que `CalculatorService` contiene las operaciones y validaciones.
3. **Estado:** explicar que `CalculatorController` guarda el display, primer número, operación y mensajes.
4. **Arquitectura:** mostrar `layers/core`, `layers/domain` y `layers/presentation`.
5. **Justificación:** explicar que Layers First separa responsabilidades y facilita mantenimiento y crecimiento.
6. **Diseño:** explicar el uso del fondo pixel-art, el gato proporcionado, botones con sombra desplazada y estética kawaii inspirada en el mockup.
