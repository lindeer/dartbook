
const readmeDefault = '''
# Introduction

''';

const summaryDefault = '''
# Summary

* [Introduction](README.md)
''';

const _langNames = {
  'de': 'Deutsch',
  'en': 'English',
  'zh': '中文',
};

String multilingual(List<String> languages) {
  return '''
${languages.map((l) => '* [${_langNames[l]}]($l)').join('\n\n')}
''';
}
