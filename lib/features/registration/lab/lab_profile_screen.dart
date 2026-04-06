import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/repository/auth_repository.dart';

// ─── Repository ──────────────────────────────────────────
class _LabRepo {
  final _sb = Supabase.instance.client;
  Future<String?> uploadDocument(String userId, File file) async {
    final ext = file.path.split('.').last;
    final path = 'lab_documents/$userId/license.$ext';
    await _sb.storage.from('lab_documents').upload(path, file, fileOptions: const FileOptions(upsert: true));
    return _sb.storage.from('lab_documents').getPublicUrl(path);
  }
  Future<void> registerLab({required String id, required String labName, required String labType, required String licenseNumber, required String contactNumber, required String officialEmail, required String address, required bool isHospitalAffiliated, String? affiliatedHospitalId, required bool hasHomeCollection, required bool hasOnlineReports, required bool hasEmergencyTesting, required bool nablAccredited, String? documentUrl}) async {
    await _sb.from('labs').upsert({'id':id,'lab_name':labName,'lab_type':labType,'license_number':licenseNumber,'contact_number':contactNumber,'official_email':officialEmail,'address':address,'is_hospital_affiliated':isHospitalAffiliated,'affiliated_hospital_id':affiliatedHospitalId,'has_home_collection':hasHomeCollection,'has_online_reports':hasOnlineReports,'has_emergency_testing':hasEmergencyTesting,'nabl_accredited':nablAccredited,'document_url':documentUrl});
  }
  Future<List<Map<String, dynamic>>> getHospitals() async {
    final r = await _sb.from('hospitals').select('id, institution_name, institution_type').order('institution_name');
    return List<Map<String, dynamic>>.from(r);
  }
}

// ─── State ────────────────────────────────────────────────
class _LabState {
  final bool isLoading; final String? error; final bool isSuccess;
  final String labName, labType, licenseNo, phone, email, address;
  final File? document;
  final bool isAffiliated; final String? hospitalId;
  final List<Map<String, dynamic>> hospitals;
  final bool hasHomeCollection, hasOnlineReports, hasEmergencyTesting, nablAccredited;
  final String loginEmail, password;

  const _LabState({this.isLoading=false,this.error,this.isSuccess=false,this.labName='',this.labType='Clinical',this.licenseNo='',this.phone='',this.email='',this.address='',this.document,this.isAffiliated=false,this.hospitalId,this.hospitals=const[],this.hasHomeCollection=false,this.hasOnlineReports=false,this.hasEmergencyTesting=false,this.nablAccredited=false,this.loginEmail='',this.password=''});

  _LabState copyWith({bool? isLoading,String? error,bool? isSuccess,String? labName,String? labType,String? licenseNo,String? phone,String? email,String? address,File? document,bool? isAffiliated,String? hospitalId,List<Map<String,dynamic>>? hospitals,bool? hasHomeCollection,bool? hasOnlineReports,bool? hasEmergencyTesting,bool? nablAccredited,String? loginEmail,String? password}) => _LabState(isLoading:isLoading??this.isLoading,error:error,isSuccess:isSuccess??this.isSuccess,labName:labName??this.labName,labType:labType??this.labType,licenseNo:licenseNo??this.licenseNo,phone:phone??this.phone,email:email??this.email,address:address??this.address,document:document??this.document,isAffiliated:isAffiliated??this.isAffiliated,hospitalId:hospitalId??this.hospitalId,hospitals:hospitals??this.hospitals,hasHomeCollection:hasHomeCollection??this.hasHomeCollection,hasOnlineReports:hasOnlineReports??this.hasOnlineReports,hasEmergencyTesting:hasEmergencyTesting??this.hasEmergencyTesting,nablAccredited:nablAccredited??this.nablAccredited,loginEmail:loginEmail??this.loginEmail,password:password??this.password);
}

class _LabNotifier extends Notifier<_LabState> {
  late AuthRepository _auth; final _repo = _LabRepo();
  @override _LabState build() { _auth = ref.read(authRepositoryProvider); return const _LabState(); }

  void setDocument(File f) => state = state.copyWith(document: f);
  void setStep1(String labName, String labType, String licenseNo, String phone, String email, String address) => state = state.copyWith(labName:labName, labType:labType, licenseNo:licenseNo, phone:phone, email:email, address:address);
  void setAffiliated(bool v) => state = state.copyWith(isAffiliated: v);
  void setHospital(String id) => state = state.copyWith(hospitalId: id);
  void setCapabilities({bool? homeCollection, bool? onlineReports, bool? emergency, bool? nabl}) => state = state.copyWith(hasHomeCollection:homeCollection??state.hasHomeCollection, hasOnlineReports:onlineReports??state.hasOnlineReports, hasEmergencyTesting:emergency??state.hasEmergencyTesting, nablAccredited:nabl??state.nablAccredited);
  void setAccount(String email, String pass) => state = state.copyWith(loginEmail: email, password: pass);

  Future<void> loadHospitals() async { try { state = state.copyWith(hospitals: await _repo.getHospitals()); } catch(_){} }

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _auth.signUp(email: state.loginEmail, password: state.password);
      if (res.user == null) throw Exception('Registration failed.'); final uid = res.user!.id;
      await _auth.updateProfile(uid: uid, firstName: state.labName, lastName: '', role: 'lab');
      await _auth.updateUserApproval(uid, false);
      String? docUrl; if (state.document != null) docUrl = await _repo.uploadDocument(uid, state.document!);
      await _repo.registerLab(id:uid, labName:state.labName, labType:state.labType, licenseNumber:state.licenseNo, contactNumber:state.phone, officialEmail:state.email, address:state.address, isHospitalAffiliated:state.isAffiliated, affiliatedHospitalId:state.isAffiliated?state.hospitalId:null, hasHomeCollection:state.hasHomeCollection, hasOnlineReports:state.hasOnlineReports, hasEmergencyTesting:state.hasEmergencyTesting, nablAccredited:state.nablAccredited, documentUrl:docUrl);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) { state = state.copyWith(isLoading: false, error: e.toString()); }
  }
}

final _labProvider = NotifierProvider<_LabNotifier, _LabState>(_LabNotifier.new);

// ─── SCREEN 1: Lab Profile ───────────────────────────────
class LabProfileScreen extends ConsumerStatefulWidget {
  const LabProfileScreen({super.key});
  @override ConsumerState<LabProfileScreen> createState() => _LS1();
}
class _LS1 extends ConsumerState<LabProfileScreen> {
  final _nameCtrl = TextEditingController(); final _licenseCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController(); String _type = 'Clinical';
  final _types = ['Clinical','Pathology','Radiology','Diagnostic','Molecular','Microbiology'];
  @override void dispose() { for (final c in [_nameCtrl,_licenseCtrl,_phoneCtrl,_emailCtrl,_addressCtrl]) c.dispose(); super.dispose(); }

  Future<void> _pickDoc() async {
    final r = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf','jpg','jpeg','png']);
    if (r?.files.single.path != null) ref.read(_labProvider.notifier).setDocument(File(r!.files.single.path!));
  }

  void _next() {
    if ([_nameCtrl,_licenseCtrl,_phoneCtrl,_emailCtrl,_addressCtrl].any((c)=>c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red)); return;
    }
    ref.read(_labProvider.notifier).setStep1(_nameCtrl.text.trim(),_type,_licenseCtrl.text.trim(),_phoneCtrl.text.trim(),_emailCtrl.text.trim(),_addressCtrl.text.trim());
    Routemaster.of(context).push(AppConstants.routeRegLabCertifications);
  }

  @override Widget build(BuildContext context) {
    final doc = ref.watch(_labProvider).document;
    return _LShell(step:'Step 1 of 3',progress:0.33,heading:'Lab Profile',subtitle:'Enter your diagnostic centre details.',onNext:_next,
      child: Column(children:[
        _f(_nameCtrl,'Lab / Centre Name *','City Diagnostics',Icons.science_outlined),const SizedBox(height:14),
        _dd('Lab Type *',_type,_types,(v)=>setState(()=>_type=v!)),const SizedBox(height:14),
        _f(_licenseCtrl,'License / NABL Number *','NABL-12345',Icons.badge_outlined),const SizedBox(height:14),
        _f(_phoneCtrl,'Contact Number *','+91 9876543210',Icons.phone_outlined,type:TextInputType.phone),const SizedBox(height:14),
        _f(_emailCtrl,'Official Email *','lab@example.com',Icons.email_outlined,type:TextInputType.emailAddress),const SizedBox(height:14),
        _f(_addressCtrl,'Address *','45 Diagnostic Street',Icons.location_on_outlined),const SizedBox(height:20),
        _dp(doc,_pickDoc),
      ]));
  }
}

// ─── SCREEN 2: Affiliation & Capabilities ────────────────
class LabCertificationsScreen extends ConsumerStatefulWidget {
  const LabCertificationsScreen({super.key});
  @override ConsumerState<LabCertificationsScreen> createState() => _LS2();
}
class _LS2 extends ConsumerState<LabCertificationsScreen> {
  @override void initState() { super.initState(); Future.microtask(()=>ref.read(_labProvider.notifier).loadHospitals()); }

  void _next() {
    final s = ref.read(_labProvider);
    if (s.isAffiliated && s.hospitalId == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select the affiliated hospital'), backgroundColor: Colors.red)); return; }
    Routemaster.of(context).push(AppConstants.routeRegLabAdmin);
  }

  @override Widget build(BuildContext context) {
    final s = ref.watch(_labProvider);
    return _LShell(step:'Step 2 of 3',progress:0.66,heading:'Affiliation & Capabilities',subtitle:'Specify hospital affiliation and services.',onNext:_next,
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        _affiliCard('Lab',s.isAffiliated,(v)=>ref.read(_labProvider.notifier).setAffiliated(v)),
        if (s.isAffiliated && s.hospitals.isNotEmpty) ...[
          const SizedBox(height:16),
          const Text('Select Hospital',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:Color(0xFF374151))),
          const SizedBox(height:8),
          ...s.hospitals.map((h)=>_radioTile(h,s.hospitalId==h['id'],()=>ref.read(_labProvider.notifier).setHospital(h['id']))),
        ],
        const SizedBox(height:20),
        const Text('Lab Capabilities',style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:Color(0xFF1E293B))),
        const SizedBox(height:12),
        _svc('Home Blood Collection',Icons.home_rounded,s.hasHomeCollection,(v)=>ref.read(_labProvider.notifier).setCapabilities(homeCollection:v),const Color(0xFF2C6BFF)),const SizedBox(height:8),
        _svc('Online / E-Reports',Icons.description_rounded,s.hasOnlineReports,(v)=>ref.read(_labProvider.notifier).setCapabilities(onlineReports:v),const Color(0xFF10B981)),const SizedBox(height:8),
        _svc('Emergency Testing',Icons.emergency_rounded,s.hasEmergencyTesting,(v)=>ref.read(_labProvider.notifier).setCapabilities(emergency:v),const Color(0xFFEF4444)),const SizedBox(height:8),
        _svc('NABL Accredited',Icons.verified_rounded,s.nablAccredited,(v)=>ref.read(_labProvider.notifier).setCapabilities(nabl:v),const Color(0xFFAF52DE)),
      ]));
  }
}

// ─── SCREEN 3: Account Setup ─────────────────────────────
class LabAdminScreen extends ConsumerStatefulWidget {
  const LabAdminScreen({super.key});
  @override ConsumerState<LabAdminScreen> createState() => _LS3();
}
class _LS3 extends ConsumerState<LabAdminScreen> {
  final _emailCtrl = TextEditingController(); final _passCtrl = TextEditingController();
  bool _obscure = true;
  @override void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email and password required'), backgroundColor: Colors.red)); return; }
    ref.read(_labProvider.notifier).setAccount(_emailCtrl.text.trim(), _passCtrl.text);
    await ref.read(_labProvider.notifier).submit();
    final s = ref.read(_labProvider);
    if (s.error != null && mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.error!), backgroundColor: Colors.red)); return; }
    if (s.isSuccess && mounted) Routemaster.of(context).replace(AppConstants.routeWaitingApproval);
  }

  @override Widget build(BuildContext context) {
    final s = ref.watch(_labProvider);
    return _LShell(step:'Step 3 of 3',progress:1.0,heading:'Account Setup',subtitle:'Create your UHA login credentials.',onNext:s.isLoading?null:_submit,nextLabel:s.isLoading?'Submitting…':'Submit Registration',isLoading:s.isLoading,
      child: Column(children:[
        _f(_emailCtrl,'Email Address *','lab@example.com',Icons.email_outlined,type:TextInputType.emailAddress),const SizedBox(height:14),
        Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Password *',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:Color(0xFF374151))),const SizedBox(height:6),
          TextField(controller:_passCtrl,obscureText:_obscure,decoration:_dec('••••••••',Icons.lock_outline,suffix:IconButton(icon:Icon(_obscure?Icons.visibility_off:Icons.visibility,size:20,color:Colors.grey),onPressed:()=>setState(()=>_obscure=!_obscure)))),
        ]),
        const SizedBox(height:20),
        _infoBox('Your lab account will be reviewed by UHA Admin before activation.'),
        if (s.error!=null)...[const SizedBox(height:10),Text(s.error!,style:const TextStyle(color:Colors.red,fontSize:13))],
      ]));
  }
}

// ─── Shell ────────────────────────────────────────────────
class _LShell extends ConsumerWidget {
  final String step, heading, subtitle; final double progress; final Widget child;
  final VoidCallback? onNext; final String nextLabel; final bool isLoading;
  const _LShell({required this.step,required this.progress,required this.heading,required this.subtitle,required this.child,this.onNext,this.nextLabel='Next Step →',this.isLoading=false});
  @override Widget build(BuildContext ctx, WidgetRef ref) => Scaffold(backgroundColor:Colors.white,body:SafeArea(child:Column(children:[
    Container(color:Colors.white,padding:const EdgeInsets.fromLTRB(4,16,16,12),child:Column(children:[
      Row(children:[
        IconButton(icon:const Icon(Icons.arrow_back_ios_new_rounded,size:20),onPressed:()=>Routemaster.of(ctx).pop()),
        const Spacer(),const Text('Lab Registration',style:TextStyle(fontWeight:FontWeight.w600,fontSize:14,color:Color(0xFF64748B))),const Spacer(),
        Text(step,style:const TextStyle(color:AppColors.primary,fontWeight:FontWeight.w600,fontSize:13)),
      ]),
      const SizedBox(height:8),
      ClipRRect(borderRadius:BorderRadius.circular(4),child:LinearProgressIndicator(value:progress,minHeight:6,color:AppColors.primary,backgroundColor:const Color(0xFFE2E8F0))),
    ])),
    Expanded(child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(heading,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Color(0xFF1E293B))),
      const SizedBox(height:4),Text(subtitle,style:const TextStyle(fontSize:13,color:Color(0xFF64748B))),const SizedBox(height:24),child,
    ]))),
    Container(padding:const EdgeInsets.fromLTRB(24,12,24,24),decoration:const BoxDecoration(color:Colors.white,border:Border(top:BorderSide(color:Color(0xFFF1F5F9)))),
      child:SizedBox(width:double.infinity,height:52,child:ElevatedButton(onPressed:onNext,style:ElevatedButton.styleFrom(backgroundColor:AppColors.primary,disabledBackgroundColor:AppColors.primary.withOpacity(0.5),foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14)),elevation:0),
        child:isLoading?const SizedBox(width:22,height:22,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2.5)):Text(nextLabel,style:const TextStyle(fontSize:15,fontWeight:FontWeight.w600))))),
  ])));
}

// ─── Shared helpers ───────────────────────────────────────
Widget _f(TextEditingController c, String label, String hint, IconData icon, {TextInputType? type}) => Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:Color(0xFF374151))),const SizedBox(height:6),TextField(controller:c,keyboardType:type,decoration:_dec(hint,icon))]);
Widget _dd(String label, String value, List<String> items, void Function(String?) onChange) => Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:Color(0xFF374151))),const SizedBox(height:6),Container(padding:const EdgeInsets.symmetric(horizontal:14),decoration:BoxDecoration(color:const Color(0xFFF8FAFC),borderRadius:BorderRadius.circular(12),border:Border.all(color:const Color(0xFFE2E8F0))),child:DropdownButtonHideUnderline(child:DropdownButton<String>(value:value,isExpanded:true,onChanged:onChange,items:items.map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(),icon:const Icon(Icons.expand_more,color:Color(0xFF64748B)))))]);
Widget _dp(File? doc, VoidCallback onTap) => GestureDetector(onTap:onTap,child:Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFF8FAFC),borderRadius:BorderRadius.circular(14),border:Border.all(color:doc!=null?AppColors.primary:const Color(0xFFE2E8F0),width:1.5)),child:Row(children:[Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(10)),child:Icon(doc!=null?Icons.check_circle:Icons.upload_file_rounded,color:AppColors.primary)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(doc!=null?'Document Selected ✓':'Upload Lab License / Certificate',style:const TextStyle(fontWeight:FontWeight.w600,fontSize:14,color:Color(0xFF1E293B))),Text(doc!=null?doc.path.split('/').last:'PDF, JPG, or PNG',style:const TextStyle(fontSize:12,color:Color(0xFF94A3B8)),overflow:TextOverflow.ellipsis)]))])));
Widget _affiliCard(String name, bool isAffiliated, void Function(bool) onToggle) => Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),decoration:BoxDecoration(color:isAffiliated?AppColors.primary.withOpacity(0.05):const Color(0xFFF8FAFC),borderRadius:BorderRadius.circular(14),border:Border.all(color:isAffiliated?AppColors.primary:const Color(0xFFE2E8F0),width:isAffiliated?1.5:1)),child:Row(children:[Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:const Color(0xFF2C6BFF).withOpacity(0.1),borderRadius:BorderRadius.circular(8)),child:const Icon(Icons.local_hospital_rounded,color:Color(0xFF2C6BFF),size:20)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Hospital-Affiliated $name',style:const TextStyle(fontWeight:FontWeight.w600,fontSize:14,color:Color(0xFF1E293B))),Text(isAffiliated?'Part of a hospital network':'Toggle ON if part of a hospital',style:const TextStyle(fontSize:12,color:Color(0xFF64748B)))])),Switch.adaptive(value:isAffiliated,onChanged:onToggle,activeColor:AppColors.primary)]));
Widget _radioTile(Map<String,dynamic> h, bool selected, VoidCallback onTap) => GestureDetector(onTap:onTap,child:AnimatedContainer(duration:const Duration(milliseconds:200),margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:selected?AppColors.primary.withOpacity(0.08):Colors.white,borderRadius:BorderRadius.circular(12),border:Border.all(color:selected?AppColors.primary:const Color(0xFFE2E8F0),width:selected?1.5:1)),child:Row(children:[Icon(selected?Icons.radio_button_checked:Icons.radio_button_unchecked,color:selected?AppColors.primary:const Color(0xFF94A3B8),size:20),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(h['institution_name']??'',style:TextStyle(fontWeight:FontWeight.w600,fontSize:14,color:selected?AppColors.primary:const Color(0xFF1E293B))),Text(h['institution_type']??'',style:const TextStyle(fontSize:12,color:Color(0xFF94A3B8)))]))])));
Widget _svc(String label, IconData icon, bool value, void Function(bool) onChange, Color color) => Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12),border:Border.all(color:const Color(0xFFF1F5F9)),boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.03),blurRadius:6,offset:const Offset(0,2))]),child:Row(children:[Container(padding:const EdgeInsets.all(7),decoration:BoxDecoration(color:color.withOpacity(0.1),borderRadius:BorderRadius.circular(8)),child:Icon(icon,color:color,size:18)),const SizedBox(width:12),Expanded(child:Text(label,style:const TextStyle(fontWeight:FontWeight.w500,fontSize:14,color:Color(0xFF1E293B)))),Switch.adaptive(value:value,onChanged:onChange,activeColor:AppColors.primary)]));
Widget _infoBox(String msg) => Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFF0FDF4),borderRadius:BorderRadius.circular(12),border:Border.all(color:const Color(0xFF86EFAC))),child:Row(children:[const Icon(Icons.info_outline,color:Color(0xFF16A34A),size:18),const SizedBox(width:10),Expanded(child:Text(msg,style:const TextStyle(fontSize:12,color:Color(0xFF15803D))))]));
InputDecoration _dec(String hint, IconData icon, {Widget? suffix}) => InputDecoration(hintText:hint,hintStyle:const TextStyle(color:Color(0xFF9CA3AF),fontSize:14),prefixIcon:Icon(icon,size:20,color:const Color(0xFF9CA3AF)),suffixIcon:suffix,filled:true,fillColor:const Color(0xFFF8FAFC),border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFFE2E8F0))),enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:Color(0xFFE2E8F0))),focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:AppColors.primary,width:1.5)),contentPadding:const EdgeInsets.symmetric(vertical:14));
