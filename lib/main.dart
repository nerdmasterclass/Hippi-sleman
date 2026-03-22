
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0D2E6E),
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(HippiApp());
}

// ── Colors ──────────────────────────────────────────────────────────────────
const kNavy   = Color(0xFF0D2E6E);
const kBlue   = Color(0xFF1A4FA0);
const kSky    = Color(0xFF2E7DD1);
const kGold   = Color(0xFFE8A820);
const kRed    = Color(0xFFC0392B);
const kGreen  = Color(0xFF27AE60);
const kOrange = Color(0xFFE67E22);
const kPurple = Color(0xFF7E57C2);
const kBg     = Color(0xFFEEF2F9);
const kMuted  = Color(0xFF7F8FA6);
const kBorder = Color(0xFFD5E0F5);
const kGrad   = LinearGradient(colors:[kNavy,kBlue,kSky],begin:Alignment.topLeft,end:Alignment.bottomRight);
const kGradG  = LinearGradient(colors:[Color(0xFFC8880A),kGold,Color(0xFFF5C842)],begin:Alignment.topLeft,end:Alignment.bottomRight);

// ── Models ───────────────────────────────────────────────────────────────────
class TxModel {
  final String id, nm, waktu, kat, tipe;
  final int jml;
  TxModel({required this.id, required this.nm, required this.waktu,
    required this.kat, required this.jml, required this.tipe});
}
class StokModel {
  final String id, nm, sat, st;
  final int qty, harga;
  StokModel({required this.id, required this.nm, required this.sat,
    required this.qty, required this.harga, required this.st});
}
class CustModel {
  final String id, nm, hp;
  final int txC, total;
  CustModel({required this.id, required this.nm, required this.hp,
    required this.txC, required this.total});
}

// ── AppData ──────────────────────────────────────────────────────────────────
class AppData extends ChangeNotifier {
  List<TxModel> txs = [
    TxModel(id:'1',nm:'Tas Batik Sleman',  waktu:'10:30',    kat:'Penjualan',   jml:85000,  tipe:'in'),
    TxModel(id:'2',nm:'Kaos UMKM Sleman',  waktu:'09:15',    kat:'Penjualan',   jml:45000,  tipe:'in'),
    TxModel(id:'3',nm:'Keramik Prambanan', waktu:'08:45',    kat:'Penjualan',   jml:120000, tipe:'in'),
    TxModel(id:'4',nm:'Restok Bahan Baku', waktu:'07:30',    kat:'Pengeluaran', jml:200000, tipe:'out'),
    TxModel(id:'5',nm:'Snack Khas Sleman', waktu:'Kemarin',  kat:'Penjualan',   jml:65000,  tipe:'in'),
    TxModel(id:'6',nm:'Lukisan Miniatur',  waktu:'Kemarin',  kat:'Penjualan',   jml:350000, tipe:'in'),
    TxModel(id:'7',nm:'Listrik Bulan Ini', waktu:'3 hr lalu',kat:'Biaya',       jml:180000, tipe:'out'),
  ];
  List<StokModel> stoks = [
    StokModel(id:'1',nm:'Tas Batik Sleman', sat:'pcs',qty:24,harga:85000, st:'ok'),
    StokModel(id:'2',nm:'Kaos UMKM Sleman', sat:'pcs',qty:3, harga:45000, st:'low'),
    StokModel(id:'3',nm:'Keramik Prambanan',sat:'pcs',qty:0, harga:120000,st:'empty'),
    StokModel(id:'4',nm:'Snack Khas Sleman',sat:'bks',qty:50,harga:25000, st:'ok'),
    StokModel(id:'5',nm:'Lukisan Miniatur', sat:'pcs',qty:7, harga:350000,st:'ok'),
    StokModel(id:'6',nm:'Souvenir Wayang',  sat:'pcs',qty:2, harga:75000, st:'low'),
    StokModel(id:'7',nm:'Bakpia Mini',      sat:'bks',qty:0, harga:30000, st:'empty'),
  ];
  List<CustModel> custs = [
    CustModel(id:'1',nm:'Ibu Sari Dewi',hp:'085-xxx-xxx',txC:12,total:480000),
    CustModel(id:'2',nm:'Pak Hendra',   hp:'081-xxx-xxx',txC:8, total:320000),
    CustModel(id:'3',nm:'Mbak Rina',    hp:'087-xxx-xxx',txC:5, total:215000),
    CustModel(id:'4',nm:'Pak Bambang',  hp:'089-xxx-xxx',txC:3, total:150000),
  ];
  bool notif=true, autoStok=true, wa=false;

  int get totalIn  => txs.where((t)=>t.tipe=='in' ).fold(0,(a,b)=>a+b.jml);
  int get totalOut => txs.where((t)=>t.tipe=='out').fold(0,(a,b)=>a+b.jml);
  int get laba     => totalIn - totalOut;
  int get totStok  => stoks.fold(0,(a,b)=>a+b.qty);

  String genId() => DateTime.now().millisecondsSinceEpoch.toString();
  String stFrom(int q) => q==0?'empty':q<=5?'low':'ok';

  void addTx(TxModel t)    { txs.insert(0,t); notifyListeners(); }
  void delTx(String id)    { txs.removeWhere((t)=>t.id==id); notifyListeners(); }
  void addStok(StokModel s){ stoks.add(s); notifyListeners(); }
  void delStok(String id)  { stoks.removeWhere((s)=>s.id==id); notifyListeners(); }
  void addCust(CustModel p){ custs.add(p); notifyListeners(); }
  void delCust(String id)  { custs.removeWhere((p)=>p.id==id); notifyListeners(); }
  void toggleNotif() { notif=!notif; notifyListeners(); }
  void toggleStok()  { autoStok=!autoStok; notifyListeners(); }
  void toggleWA()    { wa=!wa; notifyListeners(); }
}

// ── Provider ─────────────────────────────────────────────────────────────────
class _Scope extends InheritedNotifier<AppData> {
  const _Scope({required AppData data, required super.child})
    : super(notifier: data);
  static AppData of(BuildContext ctx) =>
    ctx.dependOnInheritedWidgetOfExactType<_Scope>()!.notifier!;
}

// ── Helpers ──────────────────────────────────────────────────────────────────
String rp(int n) => NumberFormat.currency(locale:'id_ID',symbol:'Rp ',decimalDigits:0).format(n);

InputDecoration inpDec(String h) => InputDecoration(
  hintText:h, hintStyle:const TextStyle(color:kMuted,fontSize:13),
  filled:true, fillColor:Colors.white,
  contentPadding:const EdgeInsets.symmetric(horizontal:14,vertical:13),
  enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(13),borderSide:const BorderSide(color:kBorder,width:2)),
  focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(13),borderSide:const BorderSide(color:kSky,width:2)),
);

Widget btn(String lbl, VoidCallback fn, {bool gold=false}) => ElevatedButton(
  onPressed:fn,
  style:ElevatedButton.styleFrom(
    backgroundColor:gold?kGold:kNavy, foregroundColor:gold?kNavy:Colors.white,
    minimumSize:const Size.fromHeight(50), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14)), elevation:0),
  child:Text(lbl,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:14)),
);

void showBtmSheet(BuildContext ctx, String title, Widget body) {
  showModalBottomSheet(
    context:ctx, isScrollControlled:true, backgroundColor:Colors.transparent,
    builder:(_)=>Padding(
      padding:EdgeInsets.only(bottom:MediaQuery.of(ctx).viewInsets.bottom),
      child:Container(
        padding:const EdgeInsets.all(22),
        decoration:const BoxDecoration(color:Colors.white,borderRadius:BorderRadius.vertical(top:Radius.circular(26))),
        child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            Text(title,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800,color:kNavy)),
            GestureDetector(onTap:()=>Navigator.pop(ctx),
              child:Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
                decoration:BoxDecoration(color:kBg,borderRadius:BorderRadius.circular(10)),
                child:const Text('Tutup',style:TextStyle(color:kMuted,fontSize:13)))),
          ]),
          const SizedBox(height:14),
          body,
          const SizedBox(height:8),
        ]),
      ),
    ),
  );
}

// ── Main App ─────────────────────────────────────────────────────────────────
class HippiApp extends StatefulWidget {
  @override State<HippiApp> createState() => _HippiAppState();
}
class _HippiAppState extends State<HippiApp> {
  final _data = AppData();
  @override
  void initState() { super.initState(); _data.addListener(()=>setState((){})); }
  @override
  void dispose() { _data.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext ctx) => _Scope(
    data: _data,
    child: MaterialApp(
      title:'HIPPI SLEMAN',
      debugShowCheckedModeBanner:false,
      theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:kNavy),scaffoldBackgroundColor:kBg),
      home:const MainScreen(),
    ),
  );
}

// ── Main Screen ───────────────────────────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _idx = 0;
  @override
  Widget build(BuildContext ctx) => Scaffold(
    body: IndexedStack(index:_idx, children:const [
      HomeScreen(), JualScreen(), StokScreen(), BukuScreen(), SettingScreen()
    ]),
    bottomNavigationBar: Container(
      decoration:BoxDecoration(color:Colors.white,boxShadow:[BoxShadow(color:kNavy.withOpacity(.1),blurRadius:20,offset:const Offset(0,-4))]),
      child:BottomNavigationBar(
        currentIndex:_idx, onTap:(i)=>setState(()=>_idx=i),
        type:BottomNavigationBarType.fixed, backgroundColor:Colors.white,
        selectedItemColor:kBlue, unselectedItemColor:kMuted, elevation:0,
        selectedLabelStyle:const TextStyle(fontWeight:FontWeight.w700,fontSize:11),
        unselectedLabelStyle:const TextStyle(fontSize:10),
        items:const [
          BottomNavigationBarItem(icon:Icon(Icons.home_rounded),         label:'Beranda'),
          BottomNavigationBarItem(icon:Icon(Icons.shopping_cart_rounded), label:'Jual'),
          BottomNavigationBarItem(icon:Icon(Icons.inventory_2_rounded),  label:'Stok'),
          BottomNavigationBarItem(icon:Icon(Icons.menu_book_rounded),    label:'Buku'),
          BottomNavigationBarItem(icon:Icon(Icons.settings_rounded),     label:'Setelan'),
        ],
      ),
    ),
  );
}

// ── Shared Widgets ────────────────────────────────────────────────────────────
class GradHdr extends StatelessWidget {
  final String title, sub; final bool back;
  const GradHdr({super.key, required this.title, this.sub='', this.back=true});
  @override
  Widget build(BuildContext ctx) => Container(
    decoration:const BoxDecoration(gradient:kGrad),
    child:SafeArea(bottom:false,child:Padding(
      padding:const EdgeInsets.fromLTRB(16,8,16,20),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        if(back) GestureDetector(
          onTap:()=>Navigator.pop(ctx),
          child:Container(width:36,height:36,decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(12)),
            child:const Icon(Icons.arrow_back_ios_new_rounded,color:Colors.white,size:16)),
        ),
        Text(title,style:const TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.w800)),
        if(sub.isNotEmpty) Text(sub,style:const TextStyle(color:Colors.white70,fontSize:12)),
      ]),
    )),
  );
}

class KCard extends StatelessWidget {
  final Widget child; final EdgeInsets? p;
  const KCard({super.key, required this.child, this.p});
  @override
  Widget build(BuildContext ctx) => Container(
    margin:const EdgeInsets.only(bottom:11),
    padding:p??const EdgeInsets.all(14),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),
      boxShadow:[BoxShadow(color:kNavy.withOpacity(.07),blurRadius:16,offset:const Offset(0,4))]),
    child:child,
  );
}

class BannerW extends StatelessWidget {
  final Widget left, right;
  const BannerW({super.key, required this.left, required this.right});
  @override
  Widget build(BuildContext ctx) => Container(
    margin:const EdgeInsets.only(bottom:12),
    padding:const EdgeInsets.all(16),
    decoration:BoxDecoration(gradient:kGrad,borderRadius:BorderRadius.circular(18)),
    child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[left,right]),
  );
}

class ChipBar extends StatelessWidget {
  final List<String> items; final int sel; final ValueChanged<int> onSel;
  const ChipBar({super.key, required this.items, required this.sel, required this.onSel});
  @override
  Widget build(BuildContext ctx) => SingleChildScrollView(
    scrollDirection:Axis.horizontal,
    child:Row(children:items.asMap().entries.map((e)=>GestureDetector(
      onTap:()=>onSel(e.key),
      child:AnimatedContainer(
        duration:const Duration(milliseconds:200),
        margin:EdgeInsets.only(right:e.key<items.length-1?8:0,bottom:12),
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:7),
        decoration:BoxDecoration(
          color:e.key==sel?kNavy:Colors.white,
          borderRadius:BorderRadius.circular(20),
          border:Border.all(color:e.key==sel?kNavy:kBorder),
        ),
        child:Text(e.value,style:TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:e.key==sel?Colors.white:kMuted)),
      ),
    )).toList()),
  );
}

class TxTile extends StatelessWidget {
  final TxModel tx; final VoidCallback? onDel;
  const TxTile({super.key, required this.tx, this.onDel});
  @override
  Widget build(BuildContext ctx) {
    final isIn = tx.tipe=='in';
    return Container(
      margin:const EdgeInsets.only(bottom:8),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15),
        boxShadow:[BoxShadow(color:kNavy.withOpacity(.05),blurRadius:9,offset:const Offset(0,2))]),
      child:ListTile(
        contentPadding:const EdgeInsets.symmetric(horizontal:13,vertical:2),
        leading:Container(width:42,height:42,
          decoration:BoxDecoration(color:isIn?const Color(0xFFE8F0FF):const Color(0xFFFFEBEE),borderRadius:BorderRadius.circular(12)),
          child:Icon(isIn?Icons.arrow_upward_rounded:Icons.arrow_downward_rounded,color:isIn?kBlue:kRed,size:20)),
        title:Text(tx.nm,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:kNavy)),
        subtitle:Text('${tx.waktu} - ${tx.kat}',style:const TextStyle(fontSize:11,color:kMuted)),
        trailing:Row(mainAxisSize:MainAxisSize.min,children:[
          Text('${isIn?"+":"-"}${rp(tx.jml)}',style:TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:isIn?kGreen:kRed)),
          if(onDel!=null) IconButton(icon:const Icon(Icons.delete_outline_rounded,size:18,color:kRed),onPressed:onDel,padding:EdgeInsets.zero,constraints:const BoxConstraints()),
        ]),
      ),
    );
  }
}

class StokTile extends StatelessWidget {
  final StokModel s; final VoidCallback? onDel;
  const StokTile({super.key, required this.s, this.onDel});
  Color get _bg => s.st=='ok'?const Color(0xFFE8F8F0):s.st=='low'?const Color(0xFFFFF8E0):const Color(0xFFFFEBEE);
  Color get _c  => s.st=='ok'?kGreen:s.st=='low'?kOrange:kRed;
  String get _lbl => s.st=='ok'?'Aman':s.st=='low'?'Sedikit':'Habis';
  @override
  Widget build(BuildContext ctx) => Container(
    margin:const EdgeInsets.only(bottom:8),
    padding:const EdgeInsets.all(13),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15),
      boxShadow:[BoxShadow(color:kNavy.withOpacity(.05),blurRadius:9,offset:const Offset(0,2))]),
    child:Row(children:[
      Container(width:46,height:46,decoration:BoxDecoration(color:_bg,borderRadius:BorderRadius.circular(13)),
        child:Icon(Icons.shopping_bag_rounded,color:_c,size:22)),
      const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(s.nm,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:kNavy)),
        Text('${s.qty} ${s.sat} - ${rp(s.harga)}/item',style:const TextStyle(fontSize:11,color:kMuted)),
      ])),
      Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:4),
        decoration:BoxDecoration(color:_bg,borderRadius:BorderRadius.circular(20)),
        child:Text(_lbl,style:TextStyle(fontSize:11,fontWeight:FontWeight.w700,color:_c))),
      if(onDel!=null) IconButton(icon:const Icon(Icons.delete_outline_rounded,size:18,color:kRed),
        onPressed:onDel,padding:EdgeInsets.zero,constraints:const BoxConstraints()),
    ]),
  );
}

class EmptyW extends StatelessWidget {
  final IconData icon; final String text;
  const EmptyW({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext ctx) => Center(child:Padding(padding:const EdgeInsets.all(40),child:Column(children:[
    Icon(icon,size:48,color:kMuted),
    const SizedBox(height:12),
    Text(text,style:const TextStyle(color:kMuted,fontWeight:FontWeight.w600)),
  ])));
}

class MBox extends StatelessWidget {
  final String lbl, val; final Color bg, c;
  const MBox({super.key, required this.lbl, required this.val, required this.bg, required this.c});
  @override
  Widget build(BuildContext ctx) => Expanded(child:Container(
    padding:const EdgeInsets.all(10),
    decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(13)),
    child:Column(children:[
      Text(val,style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:c)),
      Text(lbl,style:const TextStyle(fontSize:10,color:kMuted,fontWeight:FontWeight.w600),textAlign:TextAlign.center),
    ]),
  ));
}

// ── HOME SCREEN ───────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _go(BuildContext ctx, Widget w) => Navigator.push(ctx,MaterialPageRoute(builder:(_)=>w));
  @override
  Widget build(BuildContext ctx) {
    final d = _Scope.of(ctx);
    return Scaffold(
      backgroundColor:kBg,
      body:CustomScrollView(slivers:[
        SliverToBoxAdapter(child:Container(
          decoration:const BoxDecoration(gradient:kGrad),
          child:SafeArea(bottom:false,child:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                const Text('Selamat Datang',style:TextStyle(color:Colors.white70,fontSize:13)),
                const Text('HIPPI SLEMAN',style:TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.w800)),
                const Text('Himpunan Pengusaha Pribumi Indonesia',style:TextStyle(color:Colors.white60,fontSize:11),overflow:TextOverflow.ellipsis),
              ])),
              Container(width:50,height:50,decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(16),border:Border.all(color:Colors.white38,width:2)),
                child:const Icon(Icons.store_rounded,color:Colors.white,size:26)),
            ]),
            const SizedBox(height:14),
            Container(padding:const EdgeInsets.all(14),
              decoration:BoxDecoration(color:Colors.white.withOpacity(.15),borderRadius:BorderRadius.circular(18),border:Border.all(color:Colors.white.withOpacity(.22))),
              child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  const Text('Total Penjualan',style:TextStyle(color:Colors.white70,fontSize:11)),
                  const SizedBox(height:3),
                  Text(rp(d.totalIn),style:const TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.w800)),
                  Text('${d.txs.where((t)=>t.tipe=="in").length} transaksi',style:const TextStyle(color:Colors.white60,fontSize:11)),
                ]),
                Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
                  decoration:BoxDecoration(color:kGold.withOpacity(.3),borderRadius:BorderRadius.circular(20)),
                  child:const Text('+ 12%',style:TextStyle(color:Color(0xFFF5C842),fontWeight:FontWeight.w800))),
              ]),
            ),
          ]))),
        )),
        SliverPadding(padding:const EdgeInsets.all(14),sliver:SliverList(delegate:SliverChildListDelegate([
          GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,crossAxisSpacing:11,mainAxisSpacing:11,childAspectRatio:1.4,children:[
            _SC(icon:Icons.arrow_upward_rounded,  label:'Pemasukan',  val:rp(d.totalIn), trend:'Naik 8%', bg:const Color(0xFFE8F0FF),tc:kBlue),
            _SC(icon:Icons.arrow_downward_rounded,label:'Pengeluaran', val:rp(d.totalOut),trend:'Turun 5%',bg:const Color(0xFFFFEBEE),tc:kRed),
            _SC(icon:Icons.inventory_2_rounded,   label:'Total Stok',  val:'${d.totStok} pcs',trend:'${d.stoks.where((s)=>s.st=="empty").length} habis',bg:const Color(0xFFFFF3E0),tc:kOrange),
            _SC(icon:Icons.trending_up_rounded,   label:'Laba Bersih', val:rp(d.laba),   trend:'Naik 15%',bg:const Color(0xFFE8F8F0),tc:kGreen),
          ]),
          const SizedBox(height:14),
          const _ST(title:'Menu Utama'),
          GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:3,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.85,children:[
            _MC(icon:Icons.shopping_cart_rounded, label:'Penjualan',   bg:const Color(0xFFE8F0FF),onTap:()=>_go(ctx,const JualScreen())),
            _MC(icon:Icons.inventory_2_rounded,   label:'Stok Barang', bg:const Color(0xFFE8F8F0),onTap:()=>_go(ctx,const StokScreen()),badge:2),
            _MC(icon:Icons.menu_book_rounded,     label:'Pembukuan',   bg:const Color(0xFFEDE7F6),onTap:()=>_go(ctx,const BukuScreen())),
            _MC(icon:Icons.bar_chart_rounded,     label:'Laporan',     bg:const Color(0xFFE3F2FD),onTap:()=>_go(ctx,const LaporanScreen())),
            _MC(icon:Icons.receipt_long_rounded,  label:'Nota/Invoice',bg:const Color(0xFFFFF3E0),onTap:()=>_go(ctx,const NotaScreen())),
            _MC(icon:Icons.people_rounded,        label:'Pelanggan',   bg:const Color(0xFFFFF8E1),onTap:()=>_go(ctx,const CustScreen())),
          ]),
          const SizedBox(height:14),
          const _ST(title:'Transaksi Terakhir'),
          ...d.txs.take(4).map((t)=>TxTile(tx:t)),
          const SizedBox(height:80),
        ]))),
      ]),
    );
  }
}

class _SC extends StatelessWidget {
  final IconData icon; final String label,val,trend; final Color bg,tc;
  const _SC({required this.icon,required this.label,required this.val,required this.trend,required this.bg,required this.tc});
  @override
  Widget build(BuildContext ctx) => Container(
    padding:const EdgeInsets.all(13),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),boxShadow:[BoxShadow(color:kNavy.withOpacity(.07),blurRadius:16,offset:const Offset(0,4))]),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Container(width:36,height:36,decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(12)),child:Icon(icon,color:tc,size:18)),
      const SizedBox(height:8),
      Text(val,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w800,color:kNavy),overflow:TextOverflow.ellipsis),
      Text(label,style:const TextStyle(fontSize:11,color:kMuted,fontWeight:FontWeight.w500)),
      const SizedBox(height:4),
      Text(trend,style:TextStyle(fontSize:10,fontWeight:FontWeight.w700,color:tc)),
    ]),
  );
}

class _MC extends StatelessWidget {
  final IconData icon; final String label; final Color bg; final VoidCallback onTap; final int? badge;
  const _MC({required this.icon,required this.label,required this.bg,required this.onTap,this.badge});
  @override
  Widget build(BuildContext ctx) => GestureDetector(onTap:onTap,child:Stack(children:[
    Container(padding:const EdgeInsets.symmetric(vertical:13,horizontal:8),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(17),boxShadow:[BoxShadow(color:kNavy.withOpacity(.07),blurRadius:13,offset:const Offset(0,3))]),
      child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
        Container(width:50,height:50,decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(16)),child:Icon(icon,color:kNavy,size:25)),
        const SizedBox(height:7),
        Text(label,textAlign:TextAlign.center,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:kNavy,height:1.3)),
      ])),
    if(badge!=null) Positioned(top:6,right:6,child:Container(
      padding:const EdgeInsets.symmetric(horizontal:5,vertical:2),
      decoration:BoxDecoration(color:kRed,borderRadius:BorderRadius.circular(8)),
      child:Text('$badge',style:const TextStyle(color:Colors.white,fontSize:9,fontWeight:FontWeight.w800)),
    )),
  ]));
}

class _ST extends StatelessWidget {
  final String title;
  const _ST({required this.title});
  @override
  Widget build(BuildContext ctx) => Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:Text(title,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w700,color:kNavy)),
  );
}

// ── JUAL SCREEN ───────────────────────────────────────────────────────────────
class JualScreen extends StatefulWidget {
  const JualScreen({super.key});
  @override State<JualScreen> createState() => _JS();
}
class _JS extends State<JualScreen> {
  int _chip=0;
  final _s=TextEditingController();
  @override void dispose(){_s.dispose();super.dispose();}
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    final f=d.txs.where((t){
      final ms=_s.text.isEmpty||t.nm.toLowerCase().contains(_s.text.toLowerCase());
      final mc=_chip==0||(_chip==1&&t.tipe=='in')||(_chip==2&&t.tipe=='out');
      return ms&&mc;
    }).toList();
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Penjualan',sub:'Catat & kelola semua transaksi'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        TextField(controller:_s,onChanged:(_)=>setState((){}),decoration:inpDec('Cari transaksi...')),
        const SizedBox(height:10),
        BannerW(
          left:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('Total Penjualan',style:TextStyle(color:Colors.white70,fontSize:11)),
            Text(rp(d.totalIn),style:const TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.w800)),
          ]),
          right:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
            Text('${d.txs.where((t)=>t.tipe=="in").length} Transaksi',style:const TextStyle(color:Colors.white70,fontSize:11)),
            const Text('Naik 12%',style:TextStyle(color:Color(0xFFF5C842),fontWeight:FontWeight.w800)),
          ]),
        ),
        ChipBar(items:['Semua','Pemasukan','Pengeluaran'],sel:_chip,onSel:(i)=>setState(()=>_chip=i)),
        btn('+ Catat Penjualan Baru',()=>_addJual(ctx,d)),
        const SizedBox(height:12),
        if(f.isEmpty) const EmptyW(icon:Icons.inbox_rounded,text:'Tidak ada transaksi')
        else ...f.map((t)=>TxTile(tx:t,onDel:()=>d.delTx(t.id))),
        const SizedBox(height:80),
      ])),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:()=>_addJual(ctx,d),backgroundColor:kNavy,child:const Icon(Icons.add,color:Colors.white)));
  }
  void _addJual(BuildContext ctx, AppData d){
    final nm=TextEditingController(), price=TextEditingController();
    showBtmSheet(ctx,'Catat Penjualan Baru',Column(children:[
      TextField(controller:nm,decoration:inpDec('Nama produk *'),autofocus:true),
      const SizedBox(height:10),
      TextField(controller:price,keyboardType:TextInputType.number,decoration:inpDec('Harga total (Rp) *')),
      const SizedBox(height:14),
      btn('Simpan Penjualan',(){
        if(nm.text.trim().isEmpty||price.text.isEmpty)return;
        d.addTx(TxModel(id:d.genId(),nm:nm.text,waktu:'Baru saja',kat:'Penjualan',jml:int.tryParse(price.text)??0,tipe:'in'));
        Navigator.pop(ctx);
      }),
    ]));
  }
}

// ── STOK SCREEN ───────────────────────────────────────────────────────────────
class StokScreen extends StatefulWidget {
  const StokScreen({super.key});
  @override State<StokScreen> createState() => _SS();
}
class _SS extends State<StokScreen> {
  int _chip=0;
  final _s=TextEditingController();
  @override void dispose(){_s.dispose();super.dispose();}
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    final f=d.stoks.where((s){
      final ms=_s.text.isEmpty||s.nm.toLowerCase().contains(_s.text.toLowerCase());
      final mc=_chip==0||(_chip==1&&s.st=='ok')||(_chip==2&&s.st=='low')||(_chip==3&&s.st=='empty');
      return ms&&mc;
    }).toList();
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Stok Barang',sub:'Kelola inventaris toko Anda'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        TextField(controller:_s,onChanged:(_)=>setState((){}),decoration:inpDec('Cari barang...')),
        const SizedBox(height:10),
        Row(children:[
          MBox(lbl:'Total',val:'${d.stoks.length}',bg:const Color(0xFFE8F0FF),c:kBlue),
          const SizedBox(width:8),
          MBox(lbl:'Hampir Habis',val:'${d.stoks.where((s)=>s.st=="low").length}',bg:const Color(0xFFFFF8E0),c:kOrange),
          const SizedBox(width:8),
          MBox(lbl:'Habis',val:'${d.stoks.where((s)=>s.st=="empty").length}',bg:const Color(0xFFFFEBEE),c:kRed),
        ]),
        const SizedBox(height:10),
        ChipBar(items:['Semua','Stok OK','Hampir Habis','Habis'],sel:_chip,onSel:(i)=>setState(()=>_chip=i)),
        btn('+ Tambah Barang Baru',()=>_addStok(ctx,d)),
        const SizedBox(height:12),
        if(f.isEmpty) const EmptyW(icon:Icons.inventory_2_rounded,text:'Tidak ada barang')
        else ...f.map((s)=>StokTile(s:s,onDel:()=>d.delStok(s.id))),
        const SizedBox(height:80),
      ])),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:()=>_addStok(ctx,d),backgroundColor:kNavy,child:const Icon(Icons.add,color:Colors.white)));
  }
  void _addStok(BuildContext ctx, AppData d){
    final nm=TextEditingController(), qty=TextEditingController(), price=TextEditingController();
    String unit='pcs';
    showBtmSheet(ctx,'Tambah Barang Baru',StatefulBuilder(builder:(ctx2,ss)=>Column(children:[
      TextField(controller:nm,decoration:inpDec('Nama barang *'),autofocus:true),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:TextField(controller:qty,keyboardType:TextInputType.number,decoration:inpDec('Stok'))),
        const SizedBox(width:8),
        Expanded(child:DropdownButtonFormField<String>(value:unit,decoration:inpDec('Satuan'),
          items:['pcs','bks','kg','ltr','set','lusin'].map((u)=>DropdownMenuItem(value:u,child:Text(u))).toList(),
          onChanged:(v)=>ss(()=>unit=v??'pcs'))),
      ]),
      const SizedBox(height:10),
      TextField(controller:price,keyboardType:TextInputType.number,decoration:inpDec('Harga satuan (Rp)')),
      const SizedBox(height:14),
      btn('Simpan Barang',(){
        if(nm.text.trim().isEmpty)return;
        final q=int.tryParse(qty.text)??0;
        d.addStok(StokModel(id:d.genId(),nm:nm.text,sat:unit,qty:q,harga:int.tryParse(price.text)??0,st:d.stFrom(q)));
        Navigator.pop(ctx);
      }),
    ])));
  }
}

// ── BUKU SCREEN ───────────────────────────────────────────────────────────────
class BukuScreen extends StatelessWidget {
  const BukuScreen({super.key});
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Pembukuan',sub:'Laporan keuangan lengkap'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        Row(children:[
          Expanded(child:_CC(lbl:'Pemasukan',val:rp(d.totalIn),bg:const Color(0xFFE8F8F0),c:kGreen)),
          const SizedBox(width:9),
          Expanded(child:_CC(lbl:'Pengeluaran',val:rp(d.totalOut),bg:const Color(0xFFFFEBEE),c:kRed)),
        ]),
        const SizedBox(height:11),
        KCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Laba Bersih',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          const SizedBox(height:5),
          Text(rp(d.laba),style:TextStyle(fontSize:24,fontWeight:FontWeight.w800,color:d.laba>=0?kBlue:kRed)),
          Text(DateFormat('MMMM yyyy','id_ID').format(DateTime.now()),style:const TextStyle(fontSize:11,color:kMuted)),
        ])),
        btn('+ Catat Keuangan Baru',()=>_addBuku(ctx,d),gold:true),
        const SizedBox(height:11),
        KCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Rincian (${d.txs.length} entri)',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          const SizedBox(height:8),
          if(d.txs.isEmpty) const Center(child:Padding(padding:EdgeInsets.all(20),child:Text('Belum ada catatan',style:TextStyle(color:kMuted))))
          else ...d.txs.asMap().entries.map((e)=>Column(children:[
            Padding(padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text(e.value.nm,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600)),
                Text('${e.value.waktu} - ${e.value.kat}',style:const TextStyle(fontSize:10,color:kMuted)),
              ])),
              Text('${e.value.tipe=="in"?"+":"-"}${rp(e.value.jml)}',
                style:TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:e.value.tipe=='in'?kGreen:kRed)),
              IconButton(icon:const Icon(Icons.delete_outline_rounded,size:16,color:kRed),
                onPressed:()=>d.delTx(e.value.id),padding:EdgeInsets.zero,constraints:const BoxConstraints()),
            ])),
            if(e.key<d.txs.length-1) const Divider(height:1,color:kBorder),
          ])),
        ])),
        const SizedBox(height:80),
      ])),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:()=>_addBuku(ctx,d),backgroundColor:kNavy,child:const Icon(Icons.add,color:Colors.white)));
  }
  void _addBuku(BuildContext ctx, AppData d){
    final nm=TextEditingController(), amt=TextEditingController();
    String jenis='in';
    showBtmSheet(ctx,'Catat Keuangan',StatefulBuilder(builder:(ctx2,ss)=>Column(children:[
      TextField(controller:nm,decoration:inpDec('Keterangan *'),autofocus:true),
      const SizedBox(height:10),
      Row(children:[
        Expanded(child:GestureDetector(onTap:()=>ss(()=>jenis='in'),child:Container(
          padding:const EdgeInsets.all(12),
          decoration:BoxDecoration(color:jenis=='in'?const Color(0xFFE8F0FF):Colors.white,
            border:Border.all(color:jenis=='in'?kSky:kBorder,width:2),borderRadius:BorderRadius.circular(13)),
          child:Center(child:Text('Pemasukan',style:TextStyle(fontWeight:FontWeight.w700,color:jenis=='in'?kBlue:kMuted)))))),
        const SizedBox(width:8),
        Expanded(child:GestureDetector(onTap:()=>ss(()=>jenis='out'),child:Container(
          padding:const EdgeInsets.all(12),
          decoration:BoxDecoration(color:jenis=='out'?const Color(0xFFFFEBEE):Colors.white,
            border:Border.all(color:jenis=='out'?kRed:kBorder,width:2),borderRadius:BorderRadius.circular(13)),
          child:Center(child:Text('Pengeluaran',style:TextStyle(fontWeight:FontWeight.w700,color:jenis=='out'?kRed:kMuted)))))),
      ]),
      const SizedBox(height:10),
      TextField(controller:amt,keyboardType:TextInputType.number,decoration:inpDec('Jumlah (Rp) *')),
      const SizedBox(height:14),
      btn('Simpan',(){
        if(nm.text.trim().isEmpty||amt.text.isEmpty)return;
        d.addTx(TxModel(id:d.genId(),nm:nm.text,waktu:'Baru saja',
          kat:jenis=='in'?'Pemasukan':'Pengeluaran',jml:int.tryParse(amt.text)??0,tipe:jenis));
        Navigator.pop(ctx);
      }),
    ])));
  }
}
class _CC extends StatelessWidget {
  final String lbl,val; final Color bg,c;
  const _CC({required this.lbl,required this.val,required this.bg,required this.c});
  @override
  Widget build(BuildContext ctx) => Container(
    padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(15)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(lbl,style:const TextStyle(fontSize:11,color:kMuted,fontWeight:FontWeight.w600)),
      const SizedBox(height:4),
      Text(val,style:TextStyle(fontSize:16,fontWeight:FontWeight.w800,color:c),overflow:TextOverflow.ellipsis),
    ]),
  );
}

// ── LAPORAN SCREEN ────────────────────────────────────────────────────────────
class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});
  @override State<LaporanScreen> createState() => _LS();
}
class _LS extends State<LaporanScreen> {
  int _chip=0, _bar=5;
  final List<double> _bv=[62.0,78.0,48.0,91.0,69.0,100.0,53.0];
  final _bd=['Sen','Sel','Rab','Kam','Jum','Sab','Min'];
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Laporan',sub:'Analisis bisnis & performa'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        ChipBar(items:['7 Hari','30 Hari','3 Bulan','1 Tahun'],sel:_chip,onSel:(i)=>setState(()=>_chip=i)),
        KCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Grafik Penjualan',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          const Text('7 hari terakhir',style:TextStyle(fontSize:11,color:kMuted)),
          const SizedBox(height:12),
          SizedBox(height:120,child:Row(crossAxisAlignment:CrossAxisAlignment.end,
            children:List.generate(_bv.length,(i)=>Expanded(child:GestureDetector(
              onTap:()=>setState(()=>_bar=i),
              child:Column(mainAxisAlignment:MainAxisAlignment.end,children:[
                AnimatedContainer(duration:Duration(milliseconds:700+i*80),curve:Curves.easeOut,
                  height:_bv[i],margin:const EdgeInsets.symmetric(horizontal:3),
                  decoration:BoxDecoration(gradient:i==_bar?kGradG:kGrad,borderRadius:const BorderRadius.vertical(top:Radius.circular(7)))),
                const SizedBox(height:4),
                Text(_bd[i],style:const TextStyle(fontSize:9,color:kMuted,fontWeight:FontWeight.w600)),
              ]),
            ))),
          )),
          const SizedBox(height:8),
          const Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            Text('Total: Rp 4,5Jt',style:TextStyle(fontSize:11,color:kMuted)),
            Text('Rata-rata: Rp 643rb/hari',style:TextStyle(fontSize:11,color:kMuted)),
          ]),
        ])),
        KCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Produk Terlaris',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          const SizedBox(height:12),
          ...[<Object>['Tas Batik Sleman',0.85,kBlue],<Object>['Keramik Prambanan',0.60,kPurple],
            <Object>['Kaos UMKM Sleman',0.45,kSky],<Object>['Snack Khas Sleman',0.35,kGreen]
          ].map((p)=>Padding(padding:const EdgeInsets.only(bottom:10),child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Text(p[0] as String,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600)),
                Text('${((p[1] as double)*100).toInt()}%',style:TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:p[2] as Color)),
              ]),
              const SizedBox(height:5),
              LinearProgressIndicator(value:p[1] as double,backgroundColor:kBorder,color:p[2] as Color,minHeight:9,borderRadius:BorderRadius.circular(8)),
            ],
          ))),
        ])),
        Row(children:[
          MBox(lbl:'Transaksi',val:'${d.txs.where((t)=>t.tipe=="in").length}',bg:const Color(0xFFE8F0FF),c:kBlue),
          const SizedBox(width:9),
          MBox(lbl:'Pelanggan',val:'${d.custs.length}',bg:const Color(0xFFE8F8F0),c:kGreen),
          const SizedBox(width:9),
          MBox(lbl:'Produk Aktif',val:'${d.stoks.where((s)=>s.st!="empty").length}',bg:const Color(0xFFFFF3E0),c:kOrange),
        ]),
        const SizedBox(height:80),
      ])),
    ]));
  }
}

// ── NOTA SCREEN ───────────────────────────────────────────────────────────────
class NotaScreen extends StatelessWidget {
  const NotaScreen({super.key});
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    final items=d.txs.where((t)=>t.tipe=='in').take(3).toList();
    final total=items.fold(0,(a,b)=>a+(b as TxModel).jml);
    final no='INV/${DateTime.now().year}/${d.txs.where((t)=>t.tipe=="in").length.toString().padLeft(3,"0")}';
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Nota / Invoice',sub:'Buat & kirim nota ke pelanggan'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        KCard(p:const EdgeInsets.all(20),child:Column(children:[
          Container(width:54,height:54,decoration:BoxDecoration(color:const Color(0xFFE8F0FF),borderRadius:BorderRadius.circular(16)),
            child:const Icon(Icons.store_rounded,color:kNavy,size:28)),
          const SizedBox(height:8),
          const Text('HIPPI SLEMAN',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:kNavy)),
          const Text('Sleman, Daerah Istimewa Yogyakarta',style:TextStyle(fontSize:11,color:kMuted)),
          const SizedBox(height:2),
          Text('$no  -  ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',style:const TextStyle(fontSize:10,color:kMuted)),
          const Divider(color:kBorder,height:24),
          if(items.isEmpty) const Padding(padding:EdgeInsets.all(16),child:Text('Belum ada data penjualan',style:TextStyle(color:kMuted)))
          else ...items.asMap().entries.map((e)=>Column(children:[
            Padding(padding:const EdgeInsets.symmetric(vertical:8),child:Row(children:[
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text(e.value.nm,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600)),
                const Text('1 unit',style:TextStyle(fontSize:11,color:kMuted)),
              ])),
              Text(rp(e.value.jml),style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
            ])),
            if(e.key<items.length-1) const Divider(height:1,color:kBorder),
          ])),
          const Divider(color:kBorder,height:24),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            const Text('TOTAL',style:TextStyle(fontSize:15,fontWeight:FontWeight.w800)),
            Text(rp(total),style:const TextStyle(fontSize:15,fontWeight:FontWeight.w800,color:kBlue)),
          ]),
          const SizedBox(height:12),
          Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:kBg,borderRadius:BorderRadius.circular(12)),
            child:const Text('Terima kasih telah berbelanja di HIPPI Sleman!',textAlign:TextAlign.center,style:TextStyle(fontSize:11,color:kMuted))),
        ])),
        Row(children:[
          Expanded(child:btn('Simpan PDF',(){})),
          const SizedBox(width:9),
          Expanded(child:btn('Kirim WA',(){},gold:true)),
        ]),
        const SizedBox(height:80),
      ])),
    ]));
  }
}

// ── CUST SCREEN ───────────────────────────────────────────────────────────────
class CustScreen extends StatefulWidget {
  const CustScreen({super.key});
  @override State<CustScreen> createState() => _CS();
}
class _CS extends State<CustScreen> {
  final _s=TextEditingController();
  @override void dispose(){_s.dispose();super.dispose();}
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    final f=d.custs.where((p){
      final q=_s.text.toLowerCase();
      return q.isEmpty||p.nm.toLowerCase().contains(q)||p.hp.contains(q);
    }).toList();
    return Scaffold(backgroundColor:kBg,body:Column(children:[
      GradHdr(title:'Pelanggan',sub:'Daftar & riwayat pelanggan setia'),
      Expanded(child:ListView(padding:const EdgeInsets.all(14),children:[
        TextField(controller:_s,onChanged:(_)=>setState((){}),decoration:inpDec('Cari nama atau HP...')),
        const SizedBox(height:10),
        BannerW(
          left:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('Total Pelanggan',style:TextStyle(color:Colors.white70,fontSize:11)),
            Text('${d.custs.length} Orang',style:const TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.w800)),
          ]),
          right:const Icon(Icons.people_rounded,color:Colors.white54,size:36),
        ),
        btn('+ Tambah Pelanggan',()=>_addCust(ctx,d)),
        const SizedBox(height:12),
        if(f.isEmpty) const EmptyW(icon:Icons.people_rounded,text:'Tidak ada pelanggan')
        else ...f.map((p)=>_CT(p:p,onDel:()=>d.delCust(p.id))),
        const SizedBox(height:80),
      ])),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:()=>_addCust(ctx,d),backgroundColor:kNavy,child:const Icon(Icons.person_add_rounded,color:Colors.white)));
  }
  void _addCust(BuildContext ctx, AppData d){
    final nm=TextEditingController(), hp=TextEditingController();
    showBtmSheet(ctx,'Tambah Pelanggan',Column(children:[
      TextField(controller:nm,decoration:inpDec('Nama pelanggan *'),autofocus:true),
      const SizedBox(height:10),
      TextField(controller:hp,keyboardType:TextInputType.phone,decoration:inpDec('No. HP / WhatsApp')),
      const SizedBox(height:14),
      btn('Simpan',(){
        if(nm.text.trim().isEmpty)return;
        d.addCust(CustModel(id:d.genId(),nm:nm.text,hp:hp.text.isEmpty?'-':hp.text,txC:0,total:0));
        Navigator.pop(ctx);
      }),
    ]));
  }
}
class _CT extends StatelessWidget {
  final CustModel p; final VoidCallback? onDel;
  const _CT({required this.p,this.onDel});
  @override
  Widget build(BuildContext ctx) => Container(
    margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(13),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15),
      boxShadow:[BoxShadow(color:kNavy.withOpacity(.05),blurRadius:9,offset:const Offset(0,2))]),
    child:Row(children:[
      Container(width:46,height:46,decoration:BoxDecoration(color:const Color(0xFFE8F0FF),borderRadius:BorderRadius.circular(14)),
        child:const Icon(Icons.person_rounded,color:kBlue,size:24)),
      const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(p.nm,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:kNavy)),
        Text('${p.txC} transaksi - ${p.hp}',style:const TextStyle(fontSize:11,color:kMuted)),
      ])),
      Text(rp(p.total),style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:kBlue)),
      if(onDel!=null) IconButton(icon:const Icon(Icons.delete_outline_rounded,size:18,color:kRed),
        onPressed:onDel,padding:EdgeInsets.zero,constraints:const BoxConstraints()),
    ]),
  );
}

// ── SETTING SCREEN ────────────────────────────────────────────────────────────
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  @override
  Widget build(BuildContext ctx) {
    final d=_Scope.of(ctx);
    return Scaffold(backgroundColor:kBg,body:CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Container(
        decoration:const BoxDecoration(gradient:kGrad),
        child:SafeArea(bottom:false,child:Padding(padding:const EdgeInsets.all(18),child:
          Row(children:[
            Container(width:54,height:54,decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(16),border:Border.all(color:Colors.white38,width:2)),
              child:const Icon(Icons.store_rounded,color:Colors.white,size:28)),
            const SizedBox(width:14),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              const Text('HIPPI SLEMAN',style:TextStyle(color:Colors.white,fontSize:20,fontWeight:FontWeight.w800)),
              const Text('Toko Kerajinan & Kuliner Sleman',style:TextStyle(color:Colors.white70,fontSize:11)),
              const SizedBox(height:5),
              Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:3),
                decoration:BoxDecoration(color:kGold,borderRadius:BorderRadius.circular(8)),
                child:const Text('ID: HSL-2024-001',style:TextStyle(fontSize:10,fontWeight:FontWeight.w800,color:kNavy))),
            ])),
          ]),
        )),
      )),
      SliverPadding(padding:const EdgeInsets.all(14),sliver:SliverList(delegate:SliverChildListDelegate([
        KCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Ringkasan Toko',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700)),
          const SizedBox(height:8),
          ...[
            <String>['Total Produk','${d.stoks.length} produk'],
            <String>['Total Pelanggan','${d.custs.length} orang'],
            <String>['Total Transaksi','${d.txs.length} entri'],
            <String>['Laba Bersih',rp(d.laba)],
          ].asMap().entries.map((e)=>Column(children:[
            Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Text(e.value[0],style:const TextStyle(fontSize:12,color:kMuted)),
                Text(e.value[1],style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:kNavy)),
              ])),
            if(e.key<3) const Divider(height:1,color:kBorder),
          ])),
        ])),
        KCard(child:Column(children:[
          _Tog(ico:Icons.notifications_rounded,lbl:'Notifikasi Stok',sub:'Peringatan stok hampir habis',val:d.notif,fn:d.toggleNotif),
          const Divider(height:1,color:kBorder),
          _Tog(ico:Icons.inventory_2_rounded,lbl:'Auto Update Stok',sub:'Update otomatis saat penjualan',val:d.autoStok,fn:d.toggleStok),
          const Divider(height:1,color:kBorder),
          _Tog(ico:Icons.chat_rounded,lbl:'Kirim WA Otomatis',sub:'Nota langsung ke WhatsApp',val:d.wa,fn:d.toggleWA),
        ])),
        ...[
          <Object>[Icons.person_rounded,'Profil Toko','Edit info & logo toko',const Color(0xFFE8F0FF)],
          <Object>[Icons.credit_card_rounded,'Rekening Bank','BRI / BNI / Mandiri / BSI',const Color(0xFFE8F8F0)],
          <Object>[Icons.receipt_rounded,'Format Nota','Kustom tampilan nota',const Color(0xFFEDE7F6)],
          <Object>[Icons.lock_rounded,'Keamanan & PIN','Atur kata sandi aplikasi',const Color(0xFFFFF3E0)],
          <Object>[Icons.print_rounded,'Printer Bluetooth','Hubungkan printer struk',const Color(0xFFE3F2FD)],
          <Object>[Icons.cloud_rounded,'Backup & Restore','Simpan data ke cloud',const Color(0xFFFFF8E1)],
          <Object>[Icons.info_rounded,'Tentang Aplikasi','HIPPI SLEMAN v1.0.0',const Color(0xFFE8F0FF)],
          <Object>[Icons.logout_rounded,'Keluar','Logout dari akun',const Color(0xFFFFEBEE)],
        ].map((s)=>Container(
          margin:const EdgeInsets.only(bottom:8),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15),
            boxShadow:[BoxShadow(color:kNavy.withOpacity(.05),blurRadius:9,offset:const Offset(0,2))]),
          child:ListTile(onTap:(){},
            leading:Container(width:38,height:38,decoration:BoxDecoration(color:s[3] as Color,borderRadius:BorderRadius.circular(12)),
              child:Icon(s[0] as IconData,color:kNavy,size:18)),
            title:Text(s[1] as String,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600)),
            subtitle:Text(s[2] as String,style:const TextStyle(fontSize:11,color:kMuted)),
            trailing:const Icon(Icons.chevron_right_rounded,color:kMuted)),
        )),
        const SizedBox(height:30),
      ]))),
    ]));
  }
}
class _Tog extends StatelessWidget {
  final IconData ico; final String lbl,sub; final bool val; final VoidCallback fn;
  const _Tog({required this.ico,required this.lbl,required this.sub,required this.val,required this.fn});
  @override
  Widget build(BuildContext ctx) => Padding(padding:const EdgeInsets.symmetric(vertical:4),child:Row(children:[
    Container(width:36,height:36,decoration:BoxDecoration(color:kBg,borderRadius:BorderRadius.circular(11)),
      child:Icon(ico,color:kNavy,size:17)),
    const SizedBox(width:11),
    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(lbl,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600)),
      Text(sub,style:const TextStyle(fontSize:10,color:kMuted)),
    ])),
    Switch(value:val,onChanged:(_)=>fn(),activeColor:kSky),
  ]));
}
