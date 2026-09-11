import 'package:flutter/foundation.dart';

import '../../domain/entities/calculation_result.dart';
import '../../domain/services/calculator_service.dart';

enum CalculatorOperation { add, subtract, multiply, divide, quotient, remainder, power }

class CalculatorController extends ChangeNotifier {
  CalculatorController({CalculatorService? service})
      : _service = service ?? const CalculatorService();

  final CalculatorService _service;

  String _display = '0';
  String _expression = '';
  double? _firstNumber;
  CalculatorOperation? _operation;
  bool _waitingForSecondNumber = false;
  String? _message;
  bool _messageIsError = false;

  String get display => _display;
  String get expression => _expression;
  String? get message => _message;
  bool get messageIsError => _messageIsError;

  void inputDigit(String digit) {
    _clearMessage();
    if (_waitingForSecondNumber || _display == 'Error') {
      _display = digit;
      _waitingForSecondNumber = false;
    } else {
      _display = _display == '0' ? digit : '$_display$digit';
    }
    notifyListeners();
  }

  void inputDecimal() {
    _clearMessage();
    if (_waitingForSecondNumber || _display == 'Error') {
      _display = '0.';
      _waitingForSecondNumber = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_display == '0' || _display == 'Error') return;
    _clearMessage();
    _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
    notifyListeners();
  }

  void chooseOperation(CalculatorOperation operation) {
    _clearMessage();
    final current = double.tryParse(_display);
    if (current == null) {
      _showError('Ingresa un número válido.');
      notifyListeners();
      return;
    }

    if (_firstNumber != null && _operation != null && !_waitingForSecondNumber) {
      _calculatePending(current);
      _firstNumber = double.tryParse(_display);
    } else {
      _firstNumber = current;
    }

    _operation = operation;
    _expression = '${_format(_firstNumber ?? current)} ${_symbol(operation)}';
    _waitingForSecondNumber = true;
    notifyListeners();
  }

  void equals() {
    _clearMessage();
    final second = double.tryParse(_display);
    if (_firstNumber == null || _operation == null || second == null || _waitingForSecondNumber) {
      _showError('Escribe el segundo número antes de presionar =.');
      notifyListeners();
      return;
    }

    _calculatePending(second);
    _firstNumber = null;
    _operation = null;
    _waitingForSecondNumber = false;
    notifyListeners();
  }

  void square() => _unary((value) => _service.power(value, 2));
  void squareRoot() => _unary(_service.squareRoot);
  void logarithm10() => _unary(_service.logarithm10);

  void checkParity() {
    final second = double.tryParse(_display);
    if (_firstNumber == null || second == null || _waitingForSecondNumber) {
      _showError('Escribe N1, selecciona una operación y escribe N2.');
      notifyListeners();
      return;
    }

    _clearMessage();
    try {
      final result = _service.parity(_firstNumber!, second);
      _applyResult(result);
    } on FormatException catch (error) {
      _showError(error.message);
    }
    notifyListeners();
  }

  void clear() {
    _display = '0';
    _expression = '';
    _firstNumber = null;
    _operation = null;
    _waitingForSecondNumber = false;
    _message = null;
    _messageIsError = false;
    notifyListeners();
  }

  void _unary(CalculationResult Function(double) operation) {
    final value = double.tryParse(_display);
    if (value == null) {
      _showError('Ingresa un número válido.');
      notifyListeners();
      return;
    }
    _clearMessage();
    try {
      _applyResult(operation(value));
    } on FormatException catch (error) {
      _showError(error.message);
    }
    notifyListeners();
  }

  void _calculatePending(double second) {
    final first = _firstNumber!;
    final operation = _operation!;
    CalculationResult result;
    try {
      switch (operation) {
        case CalculatorOperation.add:
          result = _service.add(first, second);
        case CalculatorOperation.subtract:
          result = _service.subtract(first, second);
        case CalculatorOperation.multiply:
          result = _service.multiply(first, second);
        case CalculatorOperation.divide:
          result = _service.divide(first, second);
        case CalculatorOperation.quotient:
          result = _service.quotient(first, second);
        case CalculatorOperation.remainder:
          result = _service.remainder(first, second);
        case CalculatorOperation.power:
          result = _service.power(first, second);
      }
      _applyResult(result);
    } on FormatException catch (error) {
      _showError(error.message);
    }
  }

  void _applyResult(CalculationResult result) {
    _display = result.result;
    _expression = result.expression;
    _message = null;
    _messageIsError = false;
  }

  void _showError(String message) {
    _display = 'Error';
    _message = message;
    _messageIsError = true;
  }

  void _clearMessage() {
    _message = null;
    _messageIsError = false;
  }

  String _symbol(CalculatorOperation operation) {
    switch (operation) {
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

  String _format(double value) {
    if (value == value.truncateToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}
