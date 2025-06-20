// lib/widgets/add_schedule_form.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/models/schedule_model.dart';
import 'package:unitime/services/schedule_service.dart';

class AddScheduleForm extends StatefulWidget {
  final VoidCallback onJadwalSaved;
  final JadwalModel? initialJadwal;

  const AddScheduleForm({
    super.key,
    required this.onJadwalSaved,
    this.initialJadwal,
  });

  @override
  State<AddScheduleForm> createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaMatkulController = TextEditingController();
  final _kodeMatkulController = TextEditingController();
  final _kelompokController = TextEditingController();
  final _ruanganController = TextEditingController();
  final _jamMulaiController = TextEditingController();
  final _jamSelesaiController = TextEditingController();

  String? _selectedHari;
  TimeOfDay? _selectedMulai;
  TimeOfDay? _selectedSelesai;
  bool _isLoading = false;

  bool get _isEditMode => widget.initialJadwal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final jadwal = widget.initialJadwal!;
      _namaMatkulController.text = jadwal.namaMatkul;
      _kodeMatkulController.text = jadwal.kodeMatkul;
      _kelompokController.text = jadwal.kelompok;
      _ruanganController.text = jadwal.ruangan;

      // =======================================================
      // === PERBAIKAN DI SINI UNTUK MENGATASI ERROR DROPDOWN ===
      if (jadwal.hari.isNotEmpty) {
        // Normalisasi string: "selasa" -> "Selasa"
        _selectedHari = jadwal.hari[0].toUpperCase() +
            jadwal.hari.substring(1).toLowerCase();
      }
      // =======================================================

      _selectedMulai = _parseTime(jadwal.jamMulai);
      _jamMulaiController.text =
          _selectedMulai != null ? _formatTimeOfDay(_selectedMulai!) : '';

      _selectedSelesai = _parseTime(jadwal.jamSelesai);
      _jamSelesaiController.text =
          _selectedSelesai != null ? _formatTimeOfDay(_selectedSelesai!) : '';
    }
  }

  @override
  void dispose() {
    _namaMatkulController.dispose();
    _kodeMatkulController.dispose();
    _kelompokController.dispose();
    _ruanganController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.Hm().format(dt);
  }

  String _toApiTimeFormat(TimeOfDay tod) {
    return '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _pickTime({required bool isMulai}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          (isMulai ? _selectedMulai : _selectedSelesai) ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isMulai) {
          _selectedMulai = pickedTime;
          _jamMulaiController.text = _formatTimeOfDay(pickedTime);
        } else {
          _selectedSelesai = pickedTime;
          _jamSelesaiController.text = _formatTimeOfDay(pickedTime);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHari == null ||
        _selectedMulai == null ||
        _selectedSelesai == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Harap lengkapi semua field!'),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    setState(() => _isLoading = true);

    try {
      if (_isEditMode) {
        final updatedJadwal = widget.initialJadwal!.copyWith(
          namaMatkul: _namaMatkulController.text,
          kodeMatkul: _kodeMatkulController.text,
          kelompok: _kelompokController.text,
          ruangan: _ruanganController.text,
          hari: _selectedHari!,
          jamMulai: _toApiTimeFormat(_selectedMulai!),
          jamSelesai: _toApiTimeFormat(_selectedSelesai!),
        );
        await JadwalService.updateJadwal(
            widget.initialJadwal!.id.toString(), updatedJadwal);
      } else {
        final newJadwal = JadwalModel(
          id: 0,
          userId: 0,
          namaMatkul: _namaMatkulController.text,
          kodeMatkul: _kodeMatkulController.text,
          kelompok: _kelompokController.text,
          ruangan: _ruanganController.text,
          hari: _selectedHari!,
          jamMulai: _toApiTimeFormat(_selectedMulai!),
          jamSelesai: _toApiTimeFormat(_selectedSelesai!),
          createdAt: '',
        );
        await JadwalService.createJadwal(newJadwal);
      }

      if (mounted) {
        final message = _isEditMode
            ? 'Jadwal berhasil diperbarui!'
            : 'Jadwal berhasil ditambahkan!';
        Navigator.pop(context);
        widget.onJadwalSaved();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal: ${e.toString().replaceAll("Exception: ", "")}'),
          backgroundColor: Colors.red,
        ));
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
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_isEditMode ? 'Edit Jadwal' : 'Tambah Jadwal Baru',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextFormField(
                    controller: _namaMatkulController,
                    decoration:
                        const InputDecoration(labelText: 'Nama Mata Kuliah'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            controller: _kodeMatkulController,
                            decoration:
                                const InputDecoration(labelText: 'Kode Matkul'),
                            validator: (v) =>
                                v!.isEmpty ? 'Wajib diisi' : null)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: TextFormField(
                            controller: _kelompokController,
                            decoration:
                                const InputDecoration(labelText: 'Kelompok'),
                            validator: (v) =>
                                v!.isEmpty ? 'Wajib diisi' : null)),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _ruanganController,
                    decoration: const InputDecoration(labelText: 'Ruangan'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedHari,
                  decoration: const InputDecoration(labelText: 'Hari'),
                  items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
                      .map((d) =>
                          DropdownMenuItem<String>(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedHari = v),
                  validator: (v) => v == null ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            controller: _jamMulaiController,
                            decoration: const InputDecoration(
                                labelText: 'Jam Mulai',
                                prefixIcon: Icon(Icons.access_time)),
                            readOnly: true,
                            onTap: () => _pickTime(isMulai: true),
                            validator: (v) =>
                                v!.isEmpty ? 'Wajib diisi' : null)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: TextFormField(
                            controller: _jamSelesaiController,
                            decoration: const InputDecoration(
                                labelText: 'Jam Selesai',
                                prefixIcon: Icon(Icons.access_time_filled)),
                            readOnly: true,
                            onTap: () => _pickTime(isMulai: false),
                            validator: (v) =>
                                v!.isEmpty ? 'Wajib diisi' : null)),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 3, color: Colors.white))
                      : Text(
                          _isEditMode ? 'Simpan Perubahan' : 'Simpan Jadwal'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
