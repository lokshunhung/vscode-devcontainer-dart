void main() {
  String? a = 'test';
  print(a);

  a = null;
  print(a);

  Map<String, String>? b = {'c': 'd'};
  print(b?['c']);
}
