import 'dart:math' as math;

import '../entities/calculation_result.dart';

class CalculatorService {
  const CalculatorService();

  CalculationResult add(double a, double b) => _binary(a, b, '+', a + b);

  CalculationResult subtract(double a, double b) => _binary(a, b, '−', a - b);

  CalculationResult multiply(double a, double b) => _binary(a, b, '×', a * b);

  CalculationResult divide(double a, double b) {
    _validateDivisor(b);
    return _binary(a, b, '÷', a / b);
  }

  CalculationResult quotient(double a, double b) {
    _validateDivisor(b);
    final value = (a / b).truncateToDouble();
    return _binary(a, b, 'cociente', value);
  }

  CalculationResult remainder(double a, double b) {
    _validateDivisor(b);
    return _binary(a, b, 'residuo', a % b);
  }

  CalculationResult power(double base, double exponent) {
    final value = math.pow(base, exponent).toDouble();
    if (!value.isFinite) {
      throw const FormatException('La potencia no produjo un número válido.');
    }
    return CalculationResult(
      expression: '${_format(base)} ^ ${_format(exponent)}',
      result: _format(value),
    );
  }

  CalculationResult squareRoot(double value) {
    if (value < 0) {
      throw const FormatException('La raíz real no existe para números negativos.');
    }
    return CalculationResult(
      expression: '√${_format(value)}',
      result: _format(math.sqrt(value)),
    );
  }

  CalculationResult logarithm10(double value) {
    if (value <= 0) {
      throw const FormatException('LOG₁₀ requiere un número mayor que 0.');
    }
    return CalculationResult(
      expression: 'LOG₁₀(${_format(value)})',
      result: _format(math.log(value) / math.ln10),
    );
  }

  CalculationResult parity(double a, double b) {
  if (!_isInteger(a) || !_isInteger(b)) {
    throw const FormatException('PAR/IMPAR requiere dos números enteros.');
  }
  final first = a.toInt();
  final second = b.toInt();
  return CalculationResult(
    expression: 'PAR / IMPAR',
    result: '$first: ${_parity(first)}  |  $second: ${_parity(second)}',
  );
}

  void _validateDivisor(double b) {
    if (b == 0) {
      throw const FormatException('No se puede dividir entre cero.');
    }
  }

  CalculationResult _binary(double a, double b, String symbol, double value) {
    return CalculationResult(
      expression: '${_format(a)} $symbol ${_format(b)}',
      result: _format(value),
    );
  }

  bool _isInteger(double value) => value.isFinite && value == value.truncateToDouble();

  String _parity(int value) => value.isEven ? 'PAR' : 'IMPAR';

  String _format(double value) {
    if (!value.isFinite || value.isNaN) return 'Error';
    if (value == value.truncateToDouble()) return value.toInt().toString();
    return value
        .toStringAsFixed(8)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
