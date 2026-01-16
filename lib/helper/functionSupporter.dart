// ignore_for_file: file_names

stringtoFormate(String s) {
  return "${s[0]}${s.substring(1, s.length).toLowerCase()}";
}

String toFixed(var value, {int decimal = 2}) {
  if (value != null) {
    double val = double.parse(value.toString()).toDouble();

    if (val % 10 != 0) {
      return "${double.parse(val.toStringAsFixed(decimal))}0";
    } else {
      return "${double.parse(value.toString())}0";
    }
  }
  return "0";
}
