/// This class allows you to create a template, which you can pass parameters to.
/// Parameters will only be inserted into the template using [TemplateString.format]
/// when the key matches some key in the template that has the following format:
/// "{key}"
/// An example string could look like this: "some-api.org/get/{item}?amount={amount}"
/// As a Gist: https://gist.github.com/creativecreatorormaybenot/7c57666a53cbf21f2adab08b4ad84ef5
class TemplateString {
  final List<String> fixedComponents;
  final Map<int, String> genericComponents;

  int totalComponents;

  TemplateString(String template)
      : fixedComponents = <String>[],
        genericComponents = <int, String>{},
        totalComponents = 0 {
    final List<String> components = template.split('{');

    for (String component in components) {
      if (component == '') continue; // If the template starts with "{", skip the first element.

      final split = component.split('}');

      if (split.length != 1) {
        // The condition allows for template strings without parameters.
        genericComponents[totalComponents] = split.first;
        totalComponents++;
      }

      if (split.last != '') {
        fixedComponents.add(split.last);
        totalComponents++;
      }
    }
  }

  /// If a key in your template is not included in the [params],
  /// it will be replaced by `null`.
  /// Parameters for "some-api.org/get/{item}?amount={amount}" could
  /// look like this: {'item': 42, 'amount': '42'}
  /// Redundant entries in [params] are ignored.
  String format(Map<String, dynamic> params) {
    String result = '';

    int fixedComponent = 0;
    for (int i = 0; i < totalComponents; i++) {
      if (genericComponents.containsKey(i)) {
        result += '${params[genericComponents[i]]}';
        continue;
      }
      result += fixedComponents[fixedComponent++];
    }

    return result;
  }
}
