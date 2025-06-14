import 'package:flutter/material.dart';
import 'package:unitime/utils/app_colors.dart';

class InformasiPribadiScreen extends StatefulWidget {
  final String nama;
  final String universitas;
  final String email;
  final String jurusan;

  const InformasiPribadiScreen({
    super.key,
    this.nama = "John Doe",
    this.universitas = "Budi Luhur",
    this.email = "email@example.com",
    this.jurusan = "Teknik Informatika"
  });

  @override
  State<InformasiPribadiScreen> createState() => _InformasiPribadiScreenState();
}

class _InformasiPribadiScreenState extends State<InformasiPribadiScreen>
    with TickerProviderStateMixin {
  late TextEditingController _namaController;
  late TextEditingController _universitasController;
  late TextEditingController _emailController;
  late TextEditingController _jurusanController;

  bool _isEditingNama = false;
  bool _isEditingUniversitas = false;
  bool _isEditingEmail = false;
  bool _isEditingJurusan = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.nama);
    _universitasController = TextEditingController(text: widget.universitas);
    _emailController = TextEditingController(text: widget.email);
    _jurusanController = TextEditingController(text: widget.jurusan);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _universitasController.dispose();
    _emailController.dispose();
    _jurusanController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        title: const Text(
          "Informasi Pribadi",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  
                  borderRadius: BorderRadius.circular(16.0),
                  
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.darkBlue,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Edit Profil Anda",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Kelola informasi pribadi Anda dengan mudah",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Input Cards
              const SizedBox(height: 8),
              _InputCard(
                title: "Nama Lengkap",
                subtitle: _namaController.text,
                isEditing: _isEditingNama,
                controller: _namaController,
                icon: Icons.person_rounded,
                onEdit: () {
                  setState(() {
                    if (_isEditingNama) {
                      // Simpan perubahan jika perlu
                    }
                    _isEditingNama = !_isEditingNama;
                  });
                },
              ),
              _InputCard(
                title: "Email",
                subtitle: _emailController.text,
                isEditing: _isEditingEmail,
                controller: _emailController,
                icon: Icons.email_rounded,
                onEdit: () {
                  setState(() {
                    if (_isEditingEmail) {}
                    _isEditingEmail = !_isEditingEmail;
                  });
                },
              ),
              _InputCard(
                title: "Universitas",
                subtitle: _universitasController.text,
                isEditing: _isEditingUniversitas,
                controller: _universitasController,
                icon: Icons.school_rounded,
                onEdit: () {
                  setState(() {
                    if (_isEditingUniversitas) {}
                    _isEditingUniversitas = !_isEditingUniversitas;
                  });
                },
              ),
              _InputCard(
                title: "Jurusan",
                subtitle: _jurusanController.text,
                isEditing: _isEditingJurusan,
                controller: _jurusanController,
                icon: Icons.book_rounded,
                onEdit: () {
                  setState(() {
                    if (_isEditingJurusan) {}
                    _isEditingJurusan = !_isEditingJurusan;
                  });
                },
              ),

              // Save Button
              Container(
                margin: const EdgeInsets.all(20.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informasi berhasil disimpan!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightLavender,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: const Color.fromARGB(255, 104, 19, 141).withOpacity(0.4),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isEditing;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final IconData icon;

  const _InputCard({
    required this.title,
    required this.subtitle,
    required this.isEditing,
    required this.controller,
    required this.onEdit,
    required this.icon,
  });

  @override
  State<_InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<_InputCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCardColor(String title) {
    switch (title) {
      case "Nama Lengkap":
        return AppColors.cardBlue;
      case "Email":
        return AppColors.cardGreen;
      case "Universitas":
        return AppColors.cardYellow;
      case "Jurusan":
        return AppColors.cardPink;
      default:
        return Colors.white;
    }
  }

  Color _getIconColor(String title) {
    switch (title) {
      case "Nama Lengkap":
        return const Color(0xFF1976D2);
      case "Email":
        return const Color(0xFF388E3C);
      case "Universitas":
        return const Color(0xFFF57C00);
      case "Jurusan":
        return const Color(0xFFC2185B);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) => _controller.reverse(),
                onTapCancel: () => _controller.reverse(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getCardColor(widget.title),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.icon,
                          color: _getIconColor(widget.title),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 4),
                            widget.isEditing
                                ? TextField(
                                    controller: widget.controller,
                                    autofocus: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                    onSubmitted: (_) => widget.onEdit(),
                                  )
                                : Text(
                                    widget.subtitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      
                      // Edit Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.isEditing 
                              ? const Color(0xFF10B981) 
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                            widget.isEditing ? Icons.check_rounded : Icons.edit_rounded,
                            color: widget.isEditing 
                                ? Colors.white 
                                : const Color(0xFF6B7280),
                            size: 20,
                          ),
                          onPressed: widget.onEdit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}