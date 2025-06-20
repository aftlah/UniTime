
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unitime/models/tasks_model.dart';
import 'package:unitime/services/tasks_service.dart';
import 'package:unitime/widgets/add_task_form.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  late Future<List<TugasModel>> _tugasFuture;
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
    _selectedDate = DateTime.now();
    _refreshTugas();
  }

  void _refreshTugas() {
    setState(() {
      _tugasFuture = TugasService.getTugas();
    });
  }

  void _changeMonth(int direction) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + direction,
        1,
      );
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
    ));
  }

  void _showEditTugasForm(TugasModel tugas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskForm(
        onTaskSaved: _refreshTugas,
        initialTask: tugas,
      ),
    );
  }

  Future<void> _handleDeleteTugas(TugasModel tugas) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus tugas "${tugas.namaTugas}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await TugasService.deleteTugas(tugas.id.toString());
        _showSnackBar('Tugas berhasil dihapus!');
        _refreshTugas();
      } catch (e) {
        _showSnackBar(
            'Gagal menghapus tugas: ${e.toString().replaceAll("Exception: ", "")}',
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FutureBuilder<List<TugasModel>>(
        future: _tugasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error memuat tugas: ${snapshot.error}"),
            );
          }

          final allTasks = snapshot.data ?? [];
          final filteredTasks = _selectedDate == null
              ? []
              : allTasks.where((task) {
                  return DateUtils.isSameDay(task.deadline, _selectedDate!);
                }).toList();

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildCalendar(allTasks),
                  const SizedBox(height: 40),
                  _buildTasksSectionHeader(allTasks),
                  const SizedBox(height: 20),
                  if (filteredTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                          child: Text("Tidak ada tugas untuk tanggal ini.")),
                    )
                  else
                    ...filteredTasks
                        .map((tugas) => _TaskItem(
                              tugas: tugas,
                              onMutated: _refreshTugas,
                              onEdit: () => _showEditTugasForm(tugas),
                              onDelete: () => _handleDeleteTugas(tugas),
                            ))
                        .toList(),
                  const SizedBox(height: 120),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Kalender',
      style: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCalendar(List<TugasModel> allTasks) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 20),
          _buildCalendarGrid(allTasks),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_displayedMonth),
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            InkWell(
              onTap: () => _changeMonth(-1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_left, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _changeMonth(1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_right, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<TugasModel> allTasks) {
    final taskDates =
        allTasks.map((task) => DateUtils.dateOnly(task.deadline)).toSet();

    final List<String> daysOfWeek = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final startWeekday =
        (firstDayOfMonth.weekday == 7) ? 0 : firstDayOfMonth.weekday;
    final correctStartWeekday = (startWeekday == 0) ? 6 : startWeekday - 1;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek
              .map((day) => Text(day,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.grey)))
              .toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount: daysInMonth + correctStartWeekday,
          itemBuilder: (context, index) {
            if (index < correctStartWeekday) {
              return Container();
            }

            final dayNumber = index - correctStartWeekday + 1;
            final currentDate = DateTime(
                _displayedMonth.year, _displayedMonth.month, dayNumber);
            final bool isSelected = _selectedDate != null &&
                DateUtils.isSameDay(currentDate, _selectedDate!);

            final bool hasTask =
                taskDates.contains(DateUtils.dateOnly(currentDate));

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = currentDate;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF00BFA5) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasTask
                        ? const Color(0xFF00BFA5).withOpacity(0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '$dayNumber',
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTasksSectionHeader(List<TugasModel> allTasks) {
    final completedCount =
        allTasks.where((task) => task.status.toLowerCase() == 'selesai').length;
    final totalCount = allTasks.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tugas',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Selesai $completedCount/$totalCount',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TugasModel tugas;
  final VoidCallback onMutated;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskItem({
    required this.tugas,
    required this.onMutated,
    required this.onEdit,
    required this.onDelete,
  });

  void _showTaskActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Pilih Aksi',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.only(top: 12.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Ubah status tugas menjadi:',
                    style: GoogleFonts.poppins(color: Colors.black54)),
              ),
              const SizedBox(height: 8),
              _buildStatusOption(dialogContext, 'belum', 'Belum Dikerjakan'),
              _buildStatusOption(dialogContext, 'proses', 'Proses'),
              _buildStatusOption(dialogContext, 'selesai', 'Selesai'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onEdit();
              },
              child: Text('Edit Tugas',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              },
              child: Text('Hapus',
                  style: GoogleFonts.poppins(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusOption(
      BuildContext context, String statusValue, String statusText) {
    return ListTile(
      dense: true,
      title: Text(statusText, style: GoogleFonts.poppins()),
      trailing: tugas.status.toLowerCase() == statusValue
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        Navigator.of(context).pop();
        _updateStatus(context, statusValue);
      },
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(
      content: Text('Mengupdate status...'),
      duration: Duration(seconds: 1),
    ));

    try {
      final updatedTask = tugas.copyWith(status: newStatus);
      await TugasService.updateTugas(tugas.id.toString(), updatedTask);

      onMutated();
      messenger.showSnackBar(const SnackBar(
        content: Text('Status berhasil diubah!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('Gagal mengubah status: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFF9F0FF);
      case 'proses':
        return const Color(0xFFEBF5FF);
      case 'belum':
        return const Color(0xFFFFF9E6);
      default:
        return Colors.grey.shade200;
    }
  }

  String _getFormattedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return 'Selesai';
      case 'proses':
        return 'Proses';
      case 'belum':
        return 'Belum Dikerjakan';
      default:
        return status;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.deepPurple.shade300;
      case 'proses':
        return Colors.blue.shade400;
      case 'belum':
        return Colors.orange.shade400;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deadlineDate = DateUtils.dateOnly(tugas.deadline);
    final today = DateUtils.dateOnly(DateTime.now());
    final differenceInDays = deadlineDate.difference(today).inDays;
    String durationText;
    if (differenceInDays == 0) {
      durationText = 'Hari ini';
    } else if (differenceInDays > 0) {
      durationText = '$differenceInDays hari lagi';
    } else {
      final daysOverdue = differenceInDays.abs();
      durationText = 'Terlambat $daysOverdue hari';
    }

    return GestureDetector(
      onTap: () => _showTaskActionsDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _getColorForStatus(tugas.status),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tugas.namaTugas,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        color: Colors.grey.shade600, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      durationText,
                      style: GoogleFonts.poppins(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  _getFormattedStatus(tugas.status),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getStatusTextColor(tugas.status),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
