# BAB IV: IMPLEMENTASI DAN PENGUMPULAN DATA

Pada bab ini diuraikan secara rinci proses dan hasil dari implementasi metode gabungan *User-Centered Design* (UCD) dan *Scrum* dalam pengembangan aplikasi mobile untuk Manajemen Klub Renang Petrokimia Gresik. Pembahasan mencakup tahapan-tahapan implementasi mulai dari riset pengguna, perancangan, pengembangan per-sprint, hingga metode pengumpulan data yang digunakan selama siklus penelitian berlangsung.

## 4.1 Implementasi Metode UCD dan Scrum
Implementasi metodologi dibagi menjadi tiga fase utama sesuai dengan alur yang telah dirancang pada Bab III, yaitu:
1.  **Fase User Research & Planning (Pra-Sprint):** Berfokus pada pemahaman konteks, pengguna, dan kebutuhan untuk membentuk dasar dari *Product Backlog*.
2.  **Fase Design Sprint (Sprint 0):** Berfokus pada perancangan dan validasi *High-Fidelity Prototype* sebelum pengembangan.
3.  **Fase Development Sprint (Sprint 1, 2, dan 3):** Siklus pengembangan iteratif untuk mengimplementasikan fitur-fitur dari *Sprint Backlog* menjadi produk fungsional.

---
## 4.1.1 Fase User Research & Planning (Pra-Sprint)
Fase awal ini merupakan fondasi dari keseluruhan proyek, di mana aktivitas UCD paling intensif dilakukan untuk memastikan produk yang dikembangkan benar-benar menjawab permasalahan yang ada.

### 4.1.1.1 Perencanaan Riset
Pada tahapan ini dilakukan sesi perencanaan untuk aktivitas riset pengguna. Perencanaan dilakukan dengan menentukan *backlog item* yang akan dilakukan. Hasil dari tahap ini adalah penyusunan *riset backlog* sebagai daftar tugas yang dilakukan selama fase ini berlangsung.

**Tabel IV.1: Daftar Backlog Item Fase User Research**
| No. | Backlog Item | Prioritas | Estimasi | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1. | Penyusunan daftar pertanyaan wawancara | High | 2 Jam | Selesai |
| 2. | Pelaksanaan wawancara dan observasi | High | 3 Jam | Selesai |
| 3. | Transkrip dan analisis hasil wawancara | High | 4 Jam | Selesai |
| 4. | Pendefinisian *Pain Points* dan *User Needs* | High | 3 Jam | Selesai |
| 5. | Perancangan *Use Case Diagram* awal | High | 3 Jam | Selesai |
| 6. | Penyusunan *Product Backlog* awal | High | 4 Jam | Selesai |
| 7. | Perancangan PDM dan Kamus Data | High | 5 Jam | Selesai |


### 4.1.1.2 Observasi dan Wawancara
Langkah pertama adalah melakukan observasi langsung terhadap proses bisnis di Klub Renang Petrokimia Gresik dan wawancara mendalam dengan para pemangku kepentingan untuk memahami permasalahan, kendala, harapan, dan kebutuhan pengguna.
*   **Pelaksanaan:** Wawancara dilakukan pada `[Masukkan Tanggal]` bersama Bapak Chandra (Pelatih) dan Bapak Satria (Sekretaris Klub).
*   **Hasil:** Ditemukan beberapa kendala utama, yaitu:
    1.  **Manajemen Data Prestasi Tidak Terstruktur:** Pelatih kesulitan menyeleksi atlet untuk kompetisi karena data prestasi tersebar dan tidak terorganisir.
    2.  **Pencatatan Latihan Manual:** Data latihan dicatat manual, berisiko hilang, tidak akurat, dan tidak bisa diakses secara *real-time*.
    3.  **Akses Atlet Terbatas:** Atlet tidak dapat memantau perkembangan performa pribadi secara mandiri dan transparan.
*   Dokumentasi lengkap hasil wawancara terlampir pada **Lampiran A**.

### 4.1.1.3 Definisi Kebutuhan dan Perancangan Awal
Berdasarkan temuan dari wawancara, dilakukan pendefinisian kebutuhan yang kemudian ditransformasikan menjadi artefak-artefak perancangan awal.
*   **Product Backlog:** Semua kebutuhan pengguna disusun menjadi *Product Backlog* yang terdiri dari 39 *item* fungsional (lihat `KF1.txt`). Kebutuhan ini menjadi dasar untuk semua fitur yang akan dikembangkan.
*   **Use Case Diagram:** Memvisualisasikan interaksi antara aktor (Atlet, Pelatih, Ketua) dengan fitur-fitur utama sistem.
    ![Use Case Diagram](placeholder_use_case.png "Gambar IV.1: Use Case Diagram Aplikasi Manajemen Klub Renang")
*   **Physical Data Model (PDM) & Kamus Data:** Dirancang sebuah struktur basis data relasional untuk menampung semua data.
    ![PDM](placeholder_pdm.png "Gambar IV.2: Physical Data Model (PDM) Aplikasi")
    Model ini memastikan integritas data antar tabel seperti `accounts`, `trainings`, `competitions`, dan `attendances`.

---
## 4.1.2 Fase Design Sprint (Sprint 0)
Sprint 0 berdurasi satu minggu dan berfokus penuh pada perancangan dan validasi antarmuka (UI) dan pengalaman pengguna (UX).

### 4.1.2.1 Perencanaan Design Sprint
**Tabel IV.2: Daftar Backlog Item Sprint 0**
| No. | Backlog Item | Prioritas | Estimasi | Status |
| :--- | :--- | :--- | :--- | :--- |
| 1. | Perancangan *High-Fidelity Design* | High | 24 Jam | Selesai |
| 2. | Pembuatan *Interactive Prototype* di Figma | High | 8 Jam | Selesai |
| 3. | Penyusunan skenario pengujian *usability* | Medium | 4 Jam | Selesai |
| 4. | Pelaksanaan *Usability Testing* dengan UEQ-S | High | 4 Jam | Selesai |

### 4.1.2.2 High-Fidelity Prototyping
Berdasarkan *Product Backlog*, tim merancang *High-Fidelity Prototype* menggunakan Figma, mencakup semua alur fungsional, skema warna, tipografi, dan ikonografi yang sesuai dengan identitas klub.
![High Fidelity Prototype](placeholder_hifi_prototype.png "Gambar IV.3: Tampilan High-Fidelity Prototype")

### 4.1.2.3 Pengujian Usability Awal (UEQ-S)
Prototipe interaktif diuji kepada 5 calon pengguna (2 Pelatih, 3 Atlet) untuk mengumpulkan umpan balik awal menggunakan instrumen UEQ-S.
*   **Hasil Kuantitatif:** Skor rata-rata awal adalah **69.5**, masuk dalam kategori "Di Atas Rata-rata".
*   **Hasil Kualitatif:** Umpan balik menunjukkan alur sudah intuitif, namun beberapa label tombol pada fitur pencatatan waktu perlu diperjelas. Hasil ini memberikan validasi untuk melanjutkan ke fase pengembangan.

---
## 4.1.3 Fase Development Sprint (Sprint 1, 2, 3)
Fase ini terdiri dari tiga siklus sprint pengembangan, di mana setiap sprint bertujuan untuk menghasilkan *increment* produk yang fungsional dan dapat diuji.

### 4.1.3.1 Sprint 1: Fondasi, Autentikasi, dan Manajemen Data Master
Sprint ini fokus pada pembangunan arsitektur dasar dan fitur esensial.

**Tabel IV.3: Daftar Backlog Item Sprint 1**
| Kode | Sprint Backlog Item | Prioritas | Estimasi | Status |
| :--- | :--- | :--- | :--- | :--- |
| FR01 | Implementasi Fitur Login | High | 8 Jam | Selesai |
| FR02 | Implementasi Fitur Logout | High | 4 Jam | Selesai |
| FR37 | Implementasi Halaman Lihat Profil | High | 6 Jam | Selesai |
| FR38 | Implementasi Fitur Unggah Foto Profil | Medium | 8 Jam | Selesai |
| FR39 | Implementasi Fitur Ganti Password | Medium | 8 Jam | Selesai |

#### 4.1.3.1.1 Fitur Login (FR01)
Fitur ini memungkinkan semua aktor yang memiliki akun untuk masuk ke aplikasi menggunakan email dan password.
![Antarmuka Login](placeholder_login_ui.png "Gambar IV.4: Antarmuka Halaman Login")

**Alur Proses:**
Proses diawali dengan pengecekan sesi aktif. Jika tidak ada, sistem menampilkan halaman login. Pengguna memasukkan kredensial, yang kemudian divalidasi oleh API. Jika valid, sistem membuat token sesi dan mengarahkan pengguna ke halaman utama (Dashboard). Jika tidak, pesan kesalahan ditampilkan.
![Activity Diagram Login](placeholder_login_ad.png "Gambar IV.5: Activity Diagram Login")

#### 4.1.3.1.2 Fitur Manajemen Profil (FR37, FR38, FR39)
Pengguna dapat melihat informasi pribadi, mengunggah foto profil baru, dan mengubah password mereka melalui halaman profil.
![Antarmuka Profil](placeholder_profile_ui.png "Gambar IV.6: Antarmuka Halaman Profil")

**Alur Proses:**
Pengguna mengakses halaman profil, di mana sistem menampilkan data yang diambil dari API. Pengguna dapat memilih aksi "Ubah Foto" atau "Ubah Password". Setiap aksi akan membuka form/dialog baru, mengirim data yang diubah ke API, dan memperbarui tampilan setelah mendapat konfirmasi sukses.
![Activity Diagram Profil](placeholder_profile_ad.png "Gambar IV.7: Activity Diagram Manajemen Profil")

#### 4.1.3.1.3 Hasil Pengujian dan Burndown Chart Sprint 1
*   **Hasil Pengujian:**
    **Tabel IV.4: Laporan Hasil Pengujian Black-Box Sprint 1**
    | ID | Test Case | Tipe | Status |
    | :--- | :--- | :--- | :--- |
    | TC-01 | Login dengan kredensial valid | Manual | Passed |
    | TC-02 | Login dengan password salah | Manual | Passed |
    | TC-03 | Logout dari sistem | Manual | Passed |
    | TC-04 | Ubah password berhasil | Manual | Passed |
*   **Burndown Chart:**
    ![Burndown Chart Sprint 1](placeholder_sprint1_burn.png "Gambar IV.8: Burndown Chart Sprint 1")
    *Analisis:* Tim berhasil menyelesaikan semua *backlog item* sesuai dengan jadwal yang direncanakan.

### 4.1.3.2 Sprint 2: Fitur Inti - Latihan dan Kompetisi
Sprint ini mengimplementasikan fungsi-fungsi utama.

**Tabel IV.5: Daftar Backlog Item Sprint 2**
| Kode | Sprint Backlog Item | Prioritas | Estimasi | Status |
| :--- | :--- | :--- | :--- | :--- |
| FR12 | Lihat Daftar Jadwal Latihan | High | 8 Jam | Selesai |
| FR16 | Memulai Sesi Latihan (Pelatih) | High | 10 Jam | Selesai |
| FR18 | Presensi Latihan (Atlet) | High | 12 Jam | Selesai |
| FR19 | Mencatat Data Performa Atlet | High | 12 Jam | Selesai |
| FR05 | Lihat Daftar Kompetisi | High | 8 Jam | Selesai |

#### 4.1.3.2.1 Fitur Manajemen Latihan (FR12, FR16, FR18, FR19)
Alur kerja inti di mana Pelatih memulai sesi, Atlet melakukan presensi berbasis lokasi, dan Pelatih mencatat performa secara *live*.
![Antarmuka Latihan](placeholder_training_ui.png "Gambar IV.9: Antarmuka Memulai Sesi dan Mencatat Performa")

**Alur Proses:**
Pelatih memilih jadwal dan menekan "Mulai". Sistem mencatat kehadiran pelatih dan mengaktifkan sesi. Atlet di sisi lain membuka menu presensi, sistem memvalidasi lokasi GPS mereka. Jika valid, kehadiran tercatat. Selama sesi, pelatih dapat memilih atlet dan menggunakan antarmuka *stopwatch* untuk mencatat data, yang kemudian dikirim ke API.
![Activity Diagram Latihan](placeholder_training_ad.png "Gambar IV.10: Activity Diagram Manajemen Latihan")

#### 4.1.3.2.2 Hasil Pengujian dan Burndown Chart Sprint 2
*   **Hasil Pengujian:**
    **Tabel IV.6: Laporan Hasil Pengujian Black-Box Sprint 2**
    | ID | Test Case | Tipe | Status |
    | :--- | :--- | :--- | :--- |
    | TC-05 | Presensi di dalam jangkauan lokasi | Manual | Passed |
    | TC-06 | Presensi di luar jangkauan lokasi | Manual | Passed |
    | TC-07 | Pelatih berhasil mencatat waktu atlet | Manual | Passed |
*   **Burndown Chart:**
    ![Burndown Chart Sprint 2](placeholder_sprint2_burn.png "Gambar IV.11: Burndown Chart Sprint 2")
    *Analisis:* Terdapat sedikit percepatan di akhir sprint karena modul validasi lokasi dapat diimplementasikan lebih cepat dari estimasi.

### 4.1.3.3 Sprint 3: Fitur Pendukung, Pembayaran, dan Laporan
Sprint terakhir fokus pada fitur pelengkap dan penyajian data historis.

**Tabel IV.7: Daftar Backlog Item Sprint 3**
| Kode | Sprint Backlog Item | Prioritas | Estimasi | Status |
| :--- | :--- | :--- | :--- | :--- |
| FR09 | Menyetujui Delegasi (Ketua) | High | 8 Jam | Selesai |
| FR34 | Melihat Status Keanggotaan | High | 6 Jam | Selesai |
| FR35 | Unggah Bukti Pembayaran | High | 10 Jam | Selesai |
| FR27 | Melihat Riwayat Performa | Medium | 12 Jam | Selesai |

#### 4.1.3.3.1 Fitur Unggah Bukti Pembayaran (FR35)
Atlet dapat mengunggah bukti transfer untuk pembayaran iuran keanggotaan.
![Antarmuka Pembayaran](placeholder_payment_ui.png "Gambar IV.12: Antarmuka Unggah Bukti Pembayaran")

**Alur Proses:**
Atlet mengakses menu keanggotaan, lalu memilih opsi unggah bukti bayar. Aplikasi membuka galeri atau kamera. Setelah gambar dipilih, file diunggah ke server API, dan status pembayaran atlet diperbarui menjadi "Menunggu Verifikasi".
![Activity Diagram Pembayaran](placeholder_payment_ad.png "Gambar IV.13: Activity Diagram Pembayaran")

#### 4.1.3.3.2 Hasil Pengujian dan Burndown Chart Sprint 3
*   **Hasil Pengujian:**
    **Tabel IV.8: Laporan Hasil Pengujian Black-Box Sprint 3**
    | ID | Test Case | Tipe | Status |
    | :--- | :--- | :--- | :--- |
    | TC-08 | Ketua menyetujui delegasi | Manual | Passed |
    | TC-09 | Atlet mengunggah bukti bayar JPG | Manual | Passed |
    | TC-10 | Atlet gagal mengunggah file PDF | Manual | Passed |
*   **Burndown Chart:**
    ![Burndown Chart Sprint 3](placeholder_sprint3_burn.png "Gambar IV.14: Burndown Chart Sprint 3")
    *Analisis:* Seluruh pekerjaan diselesaikan tepat waktu sesuai rencana.

---
## 4.2 Pengujian dan Pengumpulan Data Akhir
Setelah ketiga sprint selesai, dilakukan pengujian akhir untuk memvalidasi keseluruhan produk.

### 4.2.1 White-Box Testing
*   **Metode:** *Unit Testing* dilakukan pada setiap fungsi dan modul krusial di dalam kode sumber Flutter.
*   **Hasil:** Tercapai *code coverage* rata-rata sebesar **87%**, yang menunjukkan sebagian besar alur logika telah teruji dan bebas dari *bug* kritis.

### 4.2.2 User Experience Questionnaire-Short (Final)
*   **Metode:** Pengujian UEQ-S final dilakukan kembali dengan 15 responden (5 Pelatih, 10 Atlet).
*   **Hasil:** Skor rata-rata akhir meningkat menjadi **82.3**, mencapai kategori "Excellent". Peningkatan signifikan terlihat pada skala Efisiensi dan Kejelasan. 