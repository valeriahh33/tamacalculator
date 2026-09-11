import 'package:flutter/foundation.dart';

import '../../domain/entities/calculation_result.dart';
import '../../domain/services/calculator_service.dart';

enum CalculatorOperation { add, subtract, multiply, divide, quotient, remainder, power }

/// Estados del flujo de la calculadora.
enum CalculatorState {
  /// Esperando el primer número.
  enteringFirstNumber,

  /// El primer número ya está listo, esperando que el usuario elija una operación.
  waitingOperation,

  /// La operación ya fue elegida, esperando el segundo número.
  enteringSecondNumber,

  /// Ya se calculó un resultado; el siguiente dígito inicia un nuevo cálculo.
  showingResult,
}

class CalculatorController extends ChangeNotifier {
  CalculatorController({CalculatorService? service})
      : _service = service ?? const CalculatorService();

  final CalculatorService _service;

  // --- Estado ---
  CalculatorState _state = CalculatorState.enteringFirstNumber;

  /// Primer número (ya confirmado).
  String _firstNumber = '';

  /// Segundo número (se va escribiendo).
  String _secondNumber = '';

  /// Operación seleccionada.
  CalculatorOperation? _operation;

  /// Resultado de la última operación.
  String _result = '';

  /// Mensaje de error o informativo.
  String? _message;
  bool _messageIsError = false;

  /// Emoji de reacción del gato.
  String _reaction = '😺';

  // --- Getters ---
  CalculatorState get state => _state;
  String get firstNumber => _firstNumber;
  String get secondNumber => _secondNumber;
  CalculatorOperation? get operation => _operation;
  String get result => _result;
  String? get message => _message;
  bool get messageIsError => _messageIsError;
  String get reaction => _reaction;

  /// Devuelve el número que se está escribiendo actualmente.
  String get _currentInput {
    switch (_state) {
      case CalculatorState.enteringFirstNumber:
      case CalculatorState.waitingOperation:
        return _firstNumber;
      case CalculatorState.enteringSecondNumber:
        return _secondNumber;
      case CalculatorState.showingResult:
        return _result;
    }
  }

  /// Texto grande que se muestra en la pantalla (el número actual).
  String get display {
    if (_state == CalculatorState.showingResult) return _result;
    return _currentInput.isEmpty ? '0' : _currentInput;
  }

  /// Expresión superior (ej: "1 + ").
  String get expression {
    if (_state == CalculatorState.enteringFirstNumber) return '';
    if (_state == CalculatorState.waitingOperation) {
      return _firstNumber;
    }
    if (_state == CalculatorState.enteringSecondNumber) {
      return '$_firstNumber ${_symbol(_operation!)}';
    }
    // showingResult
    return '$_firstNumber ${_symbol(_operation!)} $_secondNumber =';
  }

  // --- Acciones ---

  /// Escribe un dígito (0-9).
  void inputDigit(String digit) {
    _clearMessage();

    if (_state == CalculatorState.showingResult) {
      // Iniciar nuevo cálculo desde cero
      _resetForNewCalculation();
      _firstNumber = digit;
      _state = CalculatorState.enteringFirstNumber;
      _setReaction('😊');
      notifyListeners();
      return;
    }

    if (_state == CalculatorState.enteringFirstNumber) {
      _firstNumber = _firstNumber == '0' ? digit : '$_firstNumber$digit';
      _setReaction('😊');
    } else if (_state == CalculatorState.enteringSecondNumber) {
      _secondNumber = _secondNumber == '0' ? digit : '$_secondNumber$digit';
      _setReaction('😊');
    }
    // Si está en waitingOperation, ignoramos dígitos hasta que elija operación.

    notifyListeners();
  }

  /// Escribe un punto decimal.
  void inputDecimal() {
    _clearMessage();

    if (_state == CalculatorState.showingResult) {
      _resetForNewCalculation();
      _firstNumber = '0.';
      _state = CalculatorState.enteringFirstNumber;
      notifyListeners();
      return;
    }

    if (_state == CalculatorState.enteringFirstNumber) {
      if (!_firstNumber.contains('.')) {
        _firstNumber = _firstNumber.isEmpty ? '0.' : '$_firstNumber.';
      }
    } else if (_state == CalculatorState.enteringSecondNumber) {
      if (!_secondNumber.contains('.')) {
        _secondNumber = _secondNumber.isEmpty ? '0.' : '$_secondNumber.';
      }
    }
    _setReaction('🤔');
    notifyListeners();
  }

  /// Cambia el signo del número actual.
  void toggleSign() {
    if (_state == CalculatorState.showingResult) return;

    if (_state == CalculatorState.enteringFirstNumber && _firstNumber.isNotEmpty && _firstNumber != '0') {
      _firstNumber = _firstNumber.startsWith('-') ? _firstNumber.substring(1) : '-$_firstNumber';
    } else if (_state == CalculatorState.enteringSecondNumber && _secondNumber.isNotEmpty && _secondNumber != '0') {
      _secondNumber = _secondNumber.startsWith('-') ? _secondNumber.substring(1) : '-$_secondNumber';
    }
    _setReaction('😼');
    notifyListeners();
  }

  /// Selecciona una operación. Es OBLIGATORIO tener un primer número válido.
  void chooseOperation(CalculatorOperation op) {
    _clearMessage();

    // Si ya hay un resultado, permitimos operar sobre él.
    if (_state == CalculatorState.showingResult) {
      _firstNumber = _result;
      _secondNumber = '';
      _result = '';
    }

    // Solo permitimos elegir operación si ya hay un primer número.
    if (_firstNumber.isEmpty || _firstNumber == '-') {
      _showError('Primero escribe un número.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    // Si ya estamos escribiendo el segundo número y el usuario cambia de operación,
    // simplemente reemplazamos la operación.
    _operation = op;
    _state = CalculatorState.enteringSecondNumber;
    _secondNumber = '';
    _setReaction('😺');
    notifyListeners();
  }

  /// Calcula el resultado. Requiere primer número, operación y segundo número.
  void equals() {
    _clearMessage();

    if (_state != CalculatorState.enteringSecondNumber) {
      if (_state == CalculatorState.waitingOperation || _state == CalculatorState.enteringFirstNumber) {
        _showError('Selecciona una operación y escribe el segundo número.');
      }
      _setReaction('😿');
      notifyListeners();
      return;
    }

    if (_firstNumber.isEmpty || _secondNumber.isEmpty || _operation == null) {
      _showError('Faltan datos para calcular.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    final a = double.tryParse(_firstNumber);
    final b = double.tryParse(_secondNumber);

    if (a == null || b == null) {
      _showError('Números inválidos.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    try {
      CalculationResult res;
      switch (_operation!) {
        case CalculatorOperation.add:
          res = _service.add(a, b);
        case CalculatorOperation.subtract:
          res = _service.subtract(a, b);
        case CalculatorOperation.multiply:
          res = _service.multiply(a, b);
        case CalculatorOperation.divide:
          res = _service.divide(a, b);
        case CalculatorOperation.quotient:
          res = _service.quotient(a, b);
        case CalculatorOperation.remainder:
          res = _service.remainder(a, b);
        case CalculatorOperation.power:
          res = _service.power(a, b);
      }
      _result = res.result;
      _state = CalculatorState.showingResult;
      _setReaction('😸');
    } on FormatException catch (e) {
      _showError(e.message);
      _setReaction('😿');
    }
    notifyListeners();
  }

  /// Verifica par/impar de los dos números ingresados.
  /// Requiere primer número, operación (cualquiera) y segundo número.
  void checkParity() {
    _clearMessage();

    if (_firstNumber.isEmpty || _secondNumber.isEmpty) {
      _showError('Escribe los dos números para verificar PAR/IMPAR.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    final a = double.tryParse(_firstNumber);
    final b = double.tryParse(_secondNumber);
    if (a == null || b == null) {
      _showError('Números inválidos.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    try {
      final res = _service.parity(a, b);
      _result = res.result;
      _state = CalculatorState.showingResult;
      _setReaction('😻');
    } on FormatException catch (e) {
      _showError(e.message);
      _setReaction('😿');
    }
    notifyListeners();
  }

  /// Operaciones unarias (x², √, LOG) sobre el número actual.
  void square() => _unary((v) => _service.power(v, 2));
  void squareRoot() => _unary(_service.squareRoot);
  void logarithm10() => _unary(_service.logarithm10);

  void _unary(CalculationResult Function(double) operation) {
    _clearMessage();

    // Determinamos sobre qué número operar.
    final input = _state == CalculatorState.enteringSecondNumber ? _secondNumber : _firstNumber;
    if (input.isEmpty || input == '-') {
      _showError('Escribe un número primero.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    final v = double.tryParse(input);
    if (v == null) {
      _showError('Número inválido.');
      _setReaction('😿');
      notifyListeners();
      return;
    }

    try {
      final res = operation(v);
      if (_state == CalculatorState.enteringSecondNumber) {
        _secondNumber = res.result;
      } else {
        _firstNumber = res.result;
      }
      _setReaction('✨');
    } on FormatException catch (e) {
      _showError(e.message);
      _setReaction('😿');
    }
    notifyListeners();
  }

  /// Limpia todo.
  void clear() {
    _state = CalculatorState.enteringFirstNumber;
    _firstNumber = '';
    _secondNumber = '';
    _operation = null;
    _result = '';
    _message = null;
    _messageIsError = false;
    _reaction = '😺';
    notifyListeners();
  }

  // --- Internos ---

  void _resetForNewCalculation() {
    _firstNumber = '';
    _secondNumber = '';
    _operation = null;
    _result = '';
  }

  void _setReaction(String emoji) {
    _reaction = emoji;
  }

  void _showError(String msg) {
    _message = msg;
    _messageIsError = true;
  }

  void _clearMessage() {
    _message = null;
    _messageIsError = false;
  }

  String _symbol(CalculatorOperation op) {
    switch (op) {
      case CalculatorOperation.add:
        return '+';
      case CalculatorOperation.subtract:
        return '−';
      case CalculatorOperation.multiply:
        return '×';
      case CalculatorOperation.divide:
        return '÷';
      case CalculatorOperation.quotient:
        return 'COC';
      case CalculatorOperation.remainder:
        return '%';
      case CalculatorOperation.power:
        return '^';
    }
  }
}