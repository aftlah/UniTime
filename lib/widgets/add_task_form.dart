// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:unitime/models/tasks_model.dart';
// import 'package:unitime/services/tasks_service.dart';

// class AddTaskForm extends StatefulWidget {
//   final VoidCallback onTaskSaved;
//   final TugasModel? initialTask;

//   const AddTaskForm({
//     super.key,
//     required this.onTaskSaved,
//     this.initialTask,
//   });

//   @override
//   State<AddTaskForm> createState() => _AddTaskFormState();
// }

// class _AddTaskFormState extends State<AddTaskForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _namaTugasController = TextEditingController();
//   final _matkulController = TextEditingController();
//   final _deskripsiController = TextEditingController();
//   final _deadlineController = TextEditingController();

//   DateTime? _selectedDeadline;
//   bool _isLoading = false;
//   bool get _isEditMode => widget.initialTask != null;

//   @override
//   void initState() {
//     super.initState();
//     if (_isEditMode) {
//       final task = widget.initialTask!;
//       _namaTugasController.text = task.namaTugas;
//       _matkulController.text = task.matkul;
//       _deskripsiController.text = task.deskripsi;
//       _selectedDeadline = task.deadline;
//       _deadlineController.text =
//           DateFormat('dd MMMM yyyy, HH:mm').format(task.deadline);
//     }
//   }

//   @override
//   void dispose() {
//     _namaTugasController.dispose();
//     _matkulController.dispose();
//     _deskripsiController.dispose();
//     _deadlineController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDeadline() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDeadline ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate == null) return;

//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
//     );
//     if (pickedTime == null) return;

//     setState(() {
//       _selectedDeadline = DateTime(
//         pickedDate.year,
//         pickedDate.month,
//         pickedDate.day,
//         pickedTime.hour,
//         pickedTime.minute,
//       );
//       _deadlineController.text =
//           DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDeadline!);
//     });
//   }

//   void _showSnackBar(String message, {bool isError = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: isError ? Colors.red : Colors.green,
//     ));
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedDeadline == null) {
//       _showSnackBar('Harap pilih tanggal dan waktu deadline!', isError: true);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final updatedTask = widget.initialTask!.copyWith(
//         namaTugas: _namaTugasController.text,
//         matkul: _matkulController.text,
//         deskripsi: _deskripsiController.text,
//         deadline: _selectedDeadline!,
//       );
//       await TugasService.updateTugas(
//           widget.initialTask!.id.toString(), updatedTask);

//       if (mounted) {
//         Navigator.pop(context);
//         widget.onTaskSaved();
//         _showSnackBar('Tugas berhasil diperbarui!');
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar(
//             'Gagal memperbarui: ${e.toString().replaceAll("Exception: ", "")}',
//             isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'Edit Tugas',
//                   style: GoogleFonts.poppins(
//                       fontSize: 22, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 24),
//                 TextFormField(
//                   controller: _namaTugasController,
//                   decoration: const InputDecoration(labelText: 'Nama Tugas'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Nama tugas tidak boleh kosong' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _matkulController,
//                   decoration: const InputDecoration(labelText: 'Mata Kuliah'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Mata kuliah tidak boleh kosong' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _deadlineController,
//                   decoration: const InputDecoration(
//                       labelText: 'Deadline',
//                       prefixIcon: Icon(Icons.calendar_today)),
//                   readOnly: true,
//                   onTap: _pickDeadline,
//                   validator: (value) =>
//                       value!.isEmpty ? 'Deadline tidak boleh kosong' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _deskripsiController,
//                   decoration:
//                       const InputDecoration(labelText: 'Deskripsi (Opsional)'),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _submitForm,
//                   style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16)),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 3, color: Colors.white))
//                       : const Text('Simpan Perubahan'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unitime/models/tasks_model.dart';
import 'package:unitime/services/tasks_service.dart';

class AddTaskForm extends StatefulWidget {
  final VoidCallback onTaskSaved;
  final TugasModel? initialTask;

  const AddTaskForm({
    super.key,
    required this.onTaskSaved,
    this.initialTask,
  });

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaTugasController = TextEditingController();
  final _matkulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _deadlineController = TextEditingController();

  DateTime? _selectedDeadline;
  bool _isLoading = false;
  bool get _isEditMode => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final task = widget.initialTask!;
      _namaTugasController.text = task.namaTugas;
      _matkulController.text = task.matkul;
      _deskripsiController.text = task.deskripsi;
      _selectedDeadline = task.deadline;
      _deadlineController.text =
          DateFormat('dd MMMM yyyy, HH:mm').format(task.deadline);
    }
  }

  @override
  void dispose() {
    _namaTugasController.dispose();
    _matkulController.dispose();
    _deskripsiController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00BFA5), 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00BFA5), 
              ),
            ),
          ),
          child: child!,
        );
      },
      
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDeadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _deadlineController.text =
          DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDeadline!);
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
    ));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      _showSnackBar('Harap pilih tanggal dan waktu deadline!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditMode) {
        final updatedTask = widget.initialTask!.copyWith(
          namaTugas: _namaTugasController.text,
          matkul: _matkulController.text,
          deskripsi: _deskripsiController.text,
          deadline: _selectedDeadline!,
        );
        await TugasService.updateTugas(
            widget.initialTask!.id.toString(), updatedTask);
        
        _showSnackBar('Tugas berhasil diperbarui!');

      } else {
        final newTask = TugasModel(
          id: 0,
          userId: 0,
          namaTugas: _namaTugasController.text,
          matkul: _matkulController.text,
          deskripsi: _deskripsiController.text,
          deadline: _selectedDeadline!,
          status: 'belum',
          createdAt: '',
        );
        await TugasService.createTugas(newTask);
        
        _showSnackBar('Tugas berhasil ditambahkan!');
      }

      if (mounted) {
        Navigator.pop(context);
        widget.onTaskSaved();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
            'Gagal menyimpan: ${e.toString().replaceAll("Exception: ", "")}',
            isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditMode ? 'Edit Tugas' : 'Tambah Tugas Baru',
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _namaTugasController,
                  decoration: const InputDecoration(labelText: 'Nama Tugas'),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tugas tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _matkulController,
                  decoration: const InputDecoration(labelText: 'Mata Kuliah'),
                  validator: (value) =>
                      value!.isEmpty ? 'Mata kuliah tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deadlineController,
                  decoration: const InputDecoration(
                      labelText: 'Deadline',
                      prefixIcon: Icon(Icons.calendar_today_outlined)),
                  readOnly: true,
                  onTap: _pickDeadline,
                  validator: (value) =>
                      value!.isEmpty ? 'Deadline tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deskripsiController,
                  decoration:
                      const InputDecoration(labelText: 'Deskripsi (Opsional)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF00BFA5),
                      foregroundColor: Colors.white
                    ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 3, color: Colors.white))
                      : Text(_isEditMode ? 'Simpan Perubahan' : 'Simpan Tugas'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}