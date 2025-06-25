# SiMenang KRPG - Versi Testing UEQ-S

## 📋 Deskripsi

Versi khusus aplikasi SiMenang KRPG yang telah dikonfigurasi dengan data dummy untuk keperluan pengujian **User Experience Questionnaire - Short Version (UEQ-S)**. Aplikasi ini menyediakan lingkungan testing yang realistis dengan data simulasi lengkap untuk evaluasi pengalaman pengguna.

## 🎯 Tujuan Testing UEQ-S

UEQ-S adalah instrumen evaluasi pengalaman pengguna yang mengukur:
- **Pragmatic Quality**: Efisiensi, kejelasan, ketergantungan
- **Hedonic Quality**: Stimulasi, kebaruan, daya tarik

Versi testing ini memungkinkan evaluator untuk:
1. Mengeksplorasi semua fitur aplikasi dengan data yang realistis
2. Memahami flow lengkap aplikasi manajemen training
3. Memberikan penilaian objektif terhadap usability dan user experience

## 🚀 Fitur Yang Tersedia

### 📊 Dashboard
- Statistik lengkap dengan 25 atlet dummy
- 15 sesi latihan dengan berbagai status
- 6 kompetisi (mendatang, berlangsung, selesai)
- 8 kelas dengan jadwal yang bervariasi
- Grafik performa dan attendance rate

### 👥 Manajemen Atlet
- 25 profil atlet dengan data lengkap (nama Indonesia)
- Informasi personal: umur, tinggi, berat, kontak
- Riwayat prestasi dan sertifikasi
- Status aktif/non-aktif
- Avatar dinamis untuk setiap atlet

### 🏃‍♂️ Sistem Training
- 15 sesi latihan dengan tipe yang beragam:
  - Latihan Fisik Dasar
  - Latihan Teknik & Taktik
  - Sparring & Kompetisi
  - Recovery Session
- Jadwal yang realistis dengan lokasi
- Sistem absensi check-in/check-out
- Catatan progress untuk setiap sesi

### 🏆 Manajemen Kompetisi
- 6 kompetisi dengan status berbeda
- Informasi lengkap: lokasi, tanggal, hadiah
- Sistem pendaftaran peserta
- Tracking hasil dan performa

### 🎓 Manajemen Kelas
- 8 kelas dengan level berbeda (Pemula, Menengah, Lanjutan, Kompetisi)
- Jadwal training mingguan
- Kapasitas dan jumlah anggota aktual
- Sistem pembagian berdasarkan kemampuan

## ⚙️ Konfigurasi Testing

### Mode Data Dummy
```dart
// lib/config/app_config.dart
static const bool useMockMode = true;
static const bool isDummyDataForUEQSTest = true;
static const bool showDummyDataIndicator = true;
static const String dummyUserRole = 'coach'; // atau 'athlete'
```

### Parameter Testing
- **Total Atlet**: 25 profil dengan data lengkap
- **Sesi Training**: 15 sesi dengan variasi status
- **Kompetisi**: 6 event dengan timeline realistis
- **Kelas**: 8 kelas dengan jadwal berbeda
- **Catatan Absensi**: 50 record untuk analisis

### Peran Pengguna
- **Coach**: Akses penuh ke semua fitur manajemen
- **Athlete**: View terbatas fokus pada training personal

## 🎨 Tema Enhanced Green Chromatic

Aplikasi menggunakan skema warna hijau yang telah diperkaya dengan:

### Palet Warna Utama
- **Primary Green**: `#10B981` (Emerald 500)
- **Forest Green**: `#047857` (Emerald 700) 
- **Mint Green**: `#A7F3D0` (Emerald 200)
- **Seafoam Green**: `#D1FAE5` (Emerald 100)

### Warna Komplementer
- **Teal Accent**: `#14B8A6` untuk kontras
- **Warm Orange**: `#F97316` untuk aksen
- **Lime Medium**: `#65A30D` untuk variasi

### Gradient & Efek Visual
- Gradient primary untuk app bar dan tombol utama
- Shadow dengan tint hijau untuk depth
- Border dengan variasi emerald untuk konsistensi
- Background dengan tint hijau sangat halus

## 📱 Cara Menjalankan Testing

### 1. Persiapan
```bash
# Clone repository
git clone [repository-url]
cd simenang_krpg

# Install dependencies
flutter pub get
```

### 2. Konfigurasi Mode Testing
Pastikan pengaturan di `lib/config/app_config.dart`:
```dart
static const bool useMockMode = true;
static const bool isDummyDataForUEQSTest = true;
```

### 3. Mode Offline Penuh
✅ **TIDAK MEMERLUKAN BACKEND API**
- Aplikasi berjalan 100% offline dengan dummy data
- Tidak perlu menjalankan server Laravel
- Tidak perlu koneksi internet
- Semua fitur tersedia dengan data simulasi

### 4. Menjalankan Aplikasi
```bash
# Debug mode
flutter run

# Release mode untuk testing performa
flutter run --release
```

### 5. Login Dummy Data
Untuk masuk ke aplikasi dalam mode testing:
- **Username/Email**: `apa saja` (bebas isi apa pun)
- **Password**: `apa saja` (bebas isi apa pun)
- Login akan selalu berhasil dengan user dummy

### 6. Indikator Testing
Aplikasi akan menampilkan:
- **Dialog welcome** otomatis saat pertama kali masuk
- **Floating indicator** di kanan atas dengan role user
- **Loading simulation** yang realistis untuk UX
- **Feedback visual** untuk semua interaksi

## 🔍 Skenario Testing UEQ-S

### Untuk Coach Role
1. **Dashboard Overview**: Lihat statistik umum dan grafik performa
2. **Manajemen Atlet**: Browse daftar atlet, lihat detail profil
3. **Jadwal Training**: Buat/edit sesi, kelola absensi
4. **Kompetisi**: Daftarkan atlet, track hasil
5. **Classroom Management**: Atur kelas dan jadwal
6. **Reporting**: Export data dan analisis

### Untuk Athlete Role  
1. **Personal Dashboard**: Lihat jadwal training pribadi
2. **Attendance**: Check-in/out untuk sesi training
3. **Performance**: Lihat progress dan statistik personal
4. **Competitions**: Daftar kompetisi dan hasil
5. **Profile**: Update informasi pribadi

## 📊 Data Yang Tersedia

### Atlet (25 profil)
- Nama Indonesia yang realistis
- Data biometrik (tinggi, berat, umur)
- Kontak dan alamat
- Riwayat prestasi
- Status keanggotaan

### Sesi Training (15 sesi)
- Variasi jenis latihan
- Lokasi gedung olahraga yang berbeda
- Waktu dan durasi yang realistis
- Status: scheduled, ongoing, completed, cancelled
- Catatan pelatih

### Kompetisi (6 event)
- Timeline yang realistis (masa lalu, sekarang, mendatang)
- Lokasi di berbagai kota
- Kategori dan tingkat yang berbeda
- Sistem pendaftaran dan deadline

### Absensi (50 record)
- Kombinasi status: present, late, absent, excused
- Data lokasi GPS untuk check-in
- Timestamp yang akurat
- Catatan khusus

## 🎯 Fokus Evaluasi UEQ-S

### Pragmatic Quality
- **Efisiensi**: Seberapa cepat task dapat diselesaikan
- **Perspicuity**: Kejelasan navigasi dan interface
- **Dependability**: Konsistensi dan reliabilitas sistem

### Hedonic Quality
- **Stimulation**: Motivasi untuk menggunakan aplikasi
- **Novelty**: Kesan inovatif dan menarik
- **Attractiveness**: Daya tarik visual overall

### Item Evaluasi
1. menghalangi - mendukung
2. rumit - sederhana  
3. tidak efisien - efisien
4. membingungkan - jelas
5. membosankan - menarik
6. tidak menarik - menarik
7. konvensional - inventif
8. biasa - terdepan

## 📝 Catatan Implementasi

### Mock Data Service
- Menggunakan `DummyDataService` untuk generate data
- Seed yang konsisten untuk hasil yang dapat direproduksi
- Data Indonesia yang autentik (nama, kota, dll)

### Performance Considerations
- Data di-cache di memory untuk performa optimal
- Lazy loading untuk list yang panjang
- Optimized image loading dengan placeholder

### Realistic Simulation
- Timestamp yang akurat untuk semua event
- Relasi data yang logis (atlet-kelas-training)
- Status yang konsisten dengan timeline

## 🔧 Customization

### Mengubah Jumlah Data
Edit di `lib/config/app_config.dart`:
```dart
static const int mockAthletes = 25;        // Ubah jumlah atlet
static const int mockTrainingSessions = 15; // Ubah jumlah sesi
static const int mockCompetitions = 6;      // Ubah jumlah kompetisi
```

### Mengubah Role Testing
```dart
static const String dummyUserRole = 'athlete'; // atau 'coach'
```

### Menonaktifkan Indicator
```dart
static const bool showDummyDataIndicator = false;
```

## 📋 Checklist Testing UEQ-S

- [ ] Dashboard loading dan statistik tampil dengan benar
- [ ] Navigation antar screen berfungsi smooth
- [ ] List atlet dapat di-scroll dan search
- [ ] Detail atlet menampilkan informasi lengkap
- [ ] Training session dapat dibuka dan di-manage
- [ ] Sistem absensi berfungsi (check-in/out)
- [ ] Kompetisi menampilkan informasi yang akurat
- [ ] Profile management dapat diakses
- [ ] Tema hijau konsisten di seluruh aplikasi
- [ ] Performance responsive di berbagai ukuran screen
- [ ] Semua interaksi memberikan feedback yang jelas

## 🎉 Hasil Yang Diharapkan

Setelah testing dengan UEQ-S, kita akan mendapatkan:
1. **Skor pragmatic quality** untuk usability
2. **Skor hedonic quality** untuk user engagement  
3. **Overall attractiveness** untuk kesan keseluruhan
4. **Benchmark** terhadap aplikasi serupa
5. **Insight** untuk improvement areas

---

**Versi**: v1.0.0  
**Tanggal**: ${DateTime.now().toString().split(' ')[0]}  
**Mode**: UEQ-S Testing dengan Enhanced Green Chromatic Theme 