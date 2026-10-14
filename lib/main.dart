import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cek & Booking Kelas',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model data kelas
class Classroom {
  final String name;
  final String building;
  final String capacity;
  final bool isAvailable;

  Classroom({
    required this.name,
    required this.building,
    required this.capacity,
    required this.isAvailable,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Classroom> _classList = [
    Classroom(name: 'Lab Pemrograman 1', building: 'Gedung Fakultas Lt. 2', capacity: '40 Orang', isAvailable: true),
    Classroom(name: 'Ruang Teori 3.1', building: 'Gedung Kuliah Bersama Lt. 3', capacity: '50 Orang', isAvailable: false),
    Classroom(name: 'Lab Multimedia', building: 'Gedung Fakultas Lt. 3', capacity: '30 Orang', isAvailable: true),
    Classroom(name: 'Ruang Teori 1.4', building: 'Gedung Kuliah Bersama Lt. 1', capacity: '45 Orang', isAvailable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Cek Jadwal Kelas' : 'Booking Ruangan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _selectedIndex == 0 ? _buildScheduleTab() : _buildBookingForm(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Cek Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add),
            label: 'Booking Ruangan',
          ),
        ],
      ),
    );
  }

  // Tab 1: Cek Jadwal & Status Ruangan
  Widget _buildScheduleTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Ruangan & Ketersediaan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _classList.length,
              itemBuilder: (context, index) {
                final room = _classList[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: room.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        room.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: room.isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${room.building}\nKapasitas: ${room.capacity}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(
                        room.isAvailable ? 'Tersedia' : 'Terpakai',
                        style: TextStyle(color: room.isAvailable ? Colors.green.shade800 : Colors.red.shade800, fontSize: 12),
                      ),
                      backgroundColor: room.isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tab 2: Form Pengajuan Booking Ruangan
  Widget _buildBookingForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();
    String selectedRoom = 'Lab Pemrograman 1';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Form Peminjaman / Booking Kelas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Peminjam / NIM',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRoom,
              decoration: const InputDecoration(
                labelText: 'Pilih Ruangan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.room),
              ),
              items: _classList.map((room) {
                return DropdownMenuItem(
                  value: room.name,
                  child: Text(room.name),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Keperluan Peminjaman',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Keperluan harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengajuan booking berhasil dikirim! Menunggu approval.')),
                  );
                }
              },
              child: const Text('Ajukan Booking', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
