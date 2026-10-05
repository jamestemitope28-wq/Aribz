import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const AribzApp());

class AribzApp extends StatelessWidget {
  const AribzApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ARIBZ',
    theme: ThemeData(brightness: Brightness.dark, colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark), useMaterial3: true),
    home: const Dashboard(),
  );
}

class Dashboard extends StatefulWidget { const Dashboard({super.key}); @override State<Dashboard> createState()=>_DashboardState(); }
class _DashboardState extends State<Dashboard> {
  String apiUrl='https://YOUR-ARIBZ-API.example.com';
  bool autoTrading=false, demoMode=true;
  double risk=1.0;
  Map<String,dynamic>? signal;
  String status='Demo engine ready';

  Future<void> scan() async {
    if(apiUrl.contains('YOUR-ARIBZ')) { setState(()=>status='Set the API URL in Settings'); return; }
    try { final r=await http.get(Uri.parse('$apiUrl/api/v1/signal/XAUUSD')); setState(()=>status=r.statusCode==200?'Connected':'API error ${r.statusCode}'); if(r.statusCode==200) signal=jsonDecode(r.body); }
    catch(_){setState(()=>status='Connection failed');}
  }
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('ARIBZ',style:TextStyle(fontWeight:FontWeight.bold)),actions:[IconButton(icon:const Icon(Icons.settings),onPressed:()=>_settings(c))]),
    body:RefreshIndicator(onRefresh:scan,child:ListView(padding:const EdgeInsets.all(16),children:[
      Card(child:ListTile(leading:const CircleAvatar(child:Icon(Icons.auto_graph)),title:const Text('XAUUSD • M5'),subtitle:Text(status),trailing:FilledButton(onPressed:scan,child:const Text('SCAN')))),
      const SizedBox(height:12),
      if(signal!=null) _signal(signal!) else const Card(child:Padding(padding:EdgeInsets.all(20),child:Text('No confirmed setup. ARIBZ waits for liquidity sweep + CHOCH/BOS confirmation.'))),
      Card(child:SwitchListTile(title:const Text('Demo Mode'),subtitle:const Text('Keep ON while testing'),value:demoMode,onChanged:(v)=>setState(()=>demoMode=v))),
      Card(child:SwitchListTile(title:const Text('Auto Trading'),subtitle:Text(demoMode?'Demo execution only':'Live execution enabled'),value:autoTrading,onChanged:(v)=>setState(()=>autoTrading=v))),
      Card(child:ListTile(title:Text('Risk per trade: ${risk.toStringAsFixed(1)}%'),subtitle:Slider(value:risk,min:.25,max:3,divisions:11,label:'${risk.toStringAsFixed(1)}%',onChanged:(v)=>setState(()=>risk=v)))),
      Card(child:ListTile(leading:const Icon(Icons.warning_amber),title:const Text('Emergency Stop'),subtitle:const Text('Disable Auto Trading'),trailing:OutlinedButton(onPressed:()=>setState(()=>autoTrading=false),child:const Text('STOP')))),
    ])));
  Widget _signal(Map<String,dynamic>s){final side='${s['side']??'NONE'}';return Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('$side SIGNAL',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:side=='BUY'?Colors.green:side=='SELL'?Colors.red:Colors.grey)),Text('Entry: ${s['entry']??'-'}'),Text('SL: ${s['sl']??'-'}'),Text('TP: ${s['tp']??'-'}'),Text('RR: ${s['rr']??'2.0'}'),Text('Reason: ${s['reason']??'-'}')])));}
  Future<void> _settings(BuildContext c)async{final x=TextEditingController(text:apiUrl);final v=await showDialog<String>(context:c,builder:(_)=>AlertDialog(title:const Text('ARIBZ API URL'),content:TextField(controller:x,decoration:const InputDecoration(hintText:'https://...')),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Cancel')),FilledButton(onPressed:()=>Navigator.pop(c,x.text.trim()),child:const Text('Save'))]));if(v!=null&&v.isNotEmpty)setState(()=>apiUrl=v);}
}
