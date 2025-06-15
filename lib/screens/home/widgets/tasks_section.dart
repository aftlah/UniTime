import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/models/tasks_model.dart';
import 'package:unitime/services/tasks_service.dart';
import '../../../utils/app_colors.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final List<String> _days = ['Kemarin', 'Hari Ini', 'Besok'];
  String selectedDay = 'Hari Ini';
  late Future<List<TugasModel>> _tugasFuture;

  @override
  void initState() {
    super.initState();
    _refreshTugasList();
  }

  void _refreshTugasList() {
    setState(() {
      _tugasFuture = TugasService.getTugas();
    });
  }

  void _showAddTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddTaskForm(
          onTaskSaved: _refreshTugasList,
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _getTargetDate() {
    final now = DateTime.now();
    if (selectedDay == 'Kemarin') return now.subtract(const Duration(days: 1));
    if (selectedDay == 'Besok') return now.add(const Duration(days: 1));
    return now;
  }

  Future<void> _handleUpdateStatus(TugasModel task, bool isCompleted) async {
    
    final updatedTask =
        task.copyWith(status: isCompleted ? 'selesai' : 'berjalan');

    try {
    
      final success =
          await TugasService.updateTugas(task.id.toString(), updatedTask);

      if (success && mounted) {
        _refreshTugasList();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Status tugas berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Update Gagal: ${e.toString().replaceAll("Exception: ", "")}'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tugas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
          ],
        ),
        const SizedBox(height: 10),
        _buildAnimatedDaySelector(),
        const SizedBox(height: 20),
        FutureBuilder<List<TugasModel>>(
          future: _tugasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              final allTasks = snapshot.data!;
              final targetDate = _getTargetDate();
              final filteredTasks = allTasks.where((task) {
                return _isSameDay(task.deadline, targetDate);
              }).toList();

              if (filteredTasks.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskItem(filteredTasks[index]);
                },
              );
            }
            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset('assets/icons/gambar1.png', height: 110),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kamu tidak memiliki tugas untuk hari $selectedDay!",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text("Tekan tombol + untuk menambahkan tugas baru"),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showAddTaskForm,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget ini sekarang menggunakan _handleUpdateStatus ---
  Widget _buildTaskItem(TugasModel tugas) {
    final deadlineFormatted = DateFormat('dd-MM-yyyy').format(tugas.deadline);

    bool isCompleted = tugas.status == 'selesai';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // Ubah warna/opacity jika sudah selesai
        color: isCompleted
            ? Colors.grey.withOpacity(0.5)
            : AppColors.cardGreen.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_turned_in_outlined,
              color: isCompleted ? Colors.black38 : Colors.black54, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tugas.namaTugas,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    // Coret teks jika sudah selesai
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${tugas.matkul} ',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
                Text(
                  'Deadline: $deadlineFormatted',
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Checkbox(
            value: isCompleted,
            onChanged: (bool? value) {
              if (value != null) {
                _handleUpdateStatus(tugas, value);
              }
            },
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "Gagal memuat tugas: ${error.replaceAll('Exception: ', '')}",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red.shade800, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAnimatedDaySelector() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        // Anda bisa menambahkan sedikit latar belakang abu-abu di sini jika mau
        // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _days.length;
          final selectedIndex = _days.indexOf(selectedDay);

          return Stack(
            children: [
              // Ini adalah indikator yang bergeser
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: selectedIndex * itemWidth,
                child: Container(
                  width: itemWidth,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors
                        .lightLavender, // Pastikan warna ini ada di app_colors.dart
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Ini adalah teks 'Kemarin', 'Hari Ini', 'Besok'
              Row(
                children: _days.map((day) {
                  final bool isSelected = selectedDay == day;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.darkPurple // Pastikan warna ini ada
                                : AppColors
                                    .secondaryText, // Pastikan warna ini ada
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Class AddTaskForm TIDAK PERLU DIUBAH sama sekali
class AddTaskForm extends StatefulWidget {
  final VoidCallback onTaskSaved;

  const AddTaskForm({super.key, required this.onTaskSaved});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  // Seluruh kode untuk AddTaskForm sama persis dengan yang Anda miliki.
  // ...
  final _formKey = GlobalKey<FormState>();
  final _namaTugasController = TextEditingController();
  final _matkulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _deadlineController = TextEditingController();

  DateTime? _selectedDeadline;
  bool _isLoading = false;

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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Harap pilih tanggal dan waktu deadline!'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newTask = TugasModel(
        id: 0,
        userId: 0,
        namaTugas: _namaTugasController.text,
        matkul: _matkulController.text,
        deskripsi: _deskripsiController.text,
        deadline: _selectedDeadline!,
        kodeMatkul: '',
        kelompok: 'Pribadi',
        status: 'berjalan',
        createdAt: '',
      );

      await TugasService.createTugas(newTask);

      if (mounted) {
        Navigator.pop(context);
        widget.onTaskSaved();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tugas berhasil ditambahkan!'),
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
                const Text('Tambah Tugas Baru',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
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
                      prefixIcon: Icon(Icons.calendar_today)),
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
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 3))
                      : const Text('Simpan Tugas'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
