/// Форматирование цен с разделителями тысяч
String formatPrice(double value) {
  final str = value.toStringAsFixed(0);
  final buf = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
    buf.write(str[i]);
  }
  return buf.toString();
}
