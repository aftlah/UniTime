import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/models/schedule_model.dart';
import 'package:unitime/services/schedule_service.dart';
import 'package:unitime/utils/app_colors.dart';

class AddScheduleForm extends StatefulWidget {
  final VoidCallback onJadwalSaved;
  const AddScheduleForm({super.key, required this.onJadwalSaved});

  @override
  State<AddScheduleForm> createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaMatkulController = TextEditingController();
  final _kodeMatkulController = TextEditingController();
  final _kelompokController = TextEditingController();
  final _ruanganController = TextEditingController();

  String? _selectedHari;
  TimeOfDay? _selectedJamMulai;
  TimeOfDay? _selectedJamSelesai;
  bool _isLoading = false;

  final List<String> _listHari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  void dispose() {
    _namaMatkulController.dispose();
    _kodeMatkulController.dispose();
    _kelompokController.dispose();
    _ruanganController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _pickTime(BuildContext context,
      {TimeOfDay? initialTime}) async {
    return await showTimePicker(
        context: context, initialTime: initialTime ?? TimeOfDay.now());
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHari == null ||
        _selectedJamMulai == null ||
        _selectedJamSelesai == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Harap lengkapi hari dan jam!'),
          backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final format = DateFormat.Hms();
      final jamMulai = format.format(DateTime(
          0, 0, 0, _selectedJamMulai!.hour, _selectedJamMulai!.minute));
      final jamSelesai = format.format(DateTime(
          0, 0, 0, _selectedJamSelesai!.hour, _selectedJamSelesai!.minute));

      final newJadwal = JadwalModel(
        id: 0,
        userId: 0,
        namaMatkul: _namaMatkulController.text,
        kodeMatkul: _kodeMatkulController.text,
        kelompok: _kelompokController.text,
        hari: _selectedHari!,
        jamMulai: jamMulai,
        jamSelesai: jamSelesai,
        ruangan: _ruanganController.text,
        createdAt: '',
      );

      await JadwalService.createJadwal(newJadwal);

      if (mounted) {
        Navigator.pop(context);
        widget.onJadwalSaved();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Jadwal berhasil disimpan!'),
            backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Gagal: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Tambah Jadwal Kuliah',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),

                TextFormField(
                    controller: _namaMatkulController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Mata Kuliah'),
                    validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null),
                const SizedBox(height: 16),

                TextFormField(
                    controller: _kodeMatkulController,
                    decoration:
                        const InputDecoration(labelText: 'Kode Mata Kuliah'),
                    validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null),
                const SizedBox(height: 16),

                TextFormField(
                    controller: _kelompokController,
                    decoration: const InputDecoration(labelText: 'Kelompok'),
                    validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                    value: _selectedHari,
                    decoration: const InputDecoration(labelText: 'Hari'),
                    items: _listHari
                        .map((hari) =>
                            DropdownMenuItem(value: hari, child: Text(hari)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedHari = value),
                    validator: (v) => v == null ? 'Pilih hari' : null),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        final time = await _pickTime(context,
                            initialTime: _selectedJamMulai);
                        if (time != null)
                          setState(() => _selectedJamMulai = time);
                      },
                      child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Jam Mulai'),
                          child: Text(_selectedJamMulai?.format(context) ??
                              'Pilih jam')),
                    )),
                    const SizedBox(width: 16),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        final time = await _pickTime(context,
                            initialTime: _selectedJamSelesai);
                        if (time != null)
                          setState(() => _selectedJamSelesai = time);
                      },
                      child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Jam Selesai'),
                          child: Text(_selectedJamSelesai?.format(context) ??
                              'Pilih jam')),
                    )),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                    controller: _ruanganController,
                    decoration: const InputDecoration(labelText: 'Ruangan'),
                    validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null),
                const SizedBox(height: 32), // Menaikkan tombol simpan

                // Input field untuk dosen telah DIHAPUS dari sini

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.lightLavender,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.darkPurple,
                          ))
                      : const Text('Simpan Jadwal',
                          style: TextStyle(color: AppColors.darkPurple)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
