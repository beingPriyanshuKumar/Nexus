import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'd:\PROJECTS\syncait\web\SYNC-AIT\frontend\public\api\clubs.json');
  final jsonString = file.readAsStringSync();
  final List<dynamic> clubs = jsonDecode(jsonString);

  final buffer = StringBuffer();
  buffer.writeln("import 'club_model.dart';\n");
  buffer.writeln("final List<ClubModel> mockClubs = [");
  
  for (var c in clubs) {
    buffer.writeln("  ClubModel(");
    if (c['abbr'] != null) buffer.writeln("    abbr: '${_escape(c['abbr'])}',");
    if (c['name'] != null) buffer.writeln("    name: '${_escape(c['name'])}',");
    if (c['fullForm'] != null) buffer.writeln("    fullForm: '${_escape(c['fullForm'])}',");
    if (c['img'] != null) buffer.writeln("    img: '${_escape(c['img'])}',");
    if (c['desc'] != null) buffer.writeln("    desc: '${_escape(c['desc'])}',");
    if (c['focusAreas'] != null) {
      buffer.writeln("    focusAreas: ${_listToString(c['focusAreas'])},");
    }
    if (c['activities'] != null) {
      buffer.writeln("    activities: ${_listToString(c['activities'])},");
    }
    if (c['media'] != null) {
      buffer.writeln("    media: ${_listToString(c['media'])},");
    }
    if (c['who'] != null) buffer.writeln("    who: '${_escape(c['who'])}',");
    
    // Default keywords based on abbreviation or name so it's not empty
    buffer.writeln("    keywords: ['${_escape(c['abbr'] ?? '')}'],");
    buffer.writeln("  ),");
  }
  
  buffer.writeln("];");

  final outFile = File(r'd:\PROJECTS\syncait\app\syncaitApp\sync_ait_app\lib\utils\models\mock_clubs.dart');
  outFile.writeAsStringSync(buffer.toString());
  print("Generated mock_clubs.dart");
}

String _escape(dynamic s) {
  return s.toString().replaceAll("'", "\\'").replaceAll('\n', '\\n');
}

String _listToString(dynamic list) {
  if (list is! List) return '[]';
  final items = list.map((e) => "'${_escape(e)}'").join(', ');
  return '[$items]';
}
