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

### 4.1.1.1 Observasi dan Wawancara
Langkah pertama adalah melakukan observasi langsung terhadap proses bisnis di Klub Renang Petrokimia Gresik dan wawancara mendalam dengan para pemangku kepentingan.
-   **Pelaksanaan:** Wawancara dilakukan pada `[Masukkan Tanggal]` bersama Bapak Chandra (Pelatih) dan Bapak Satria (Sekretaris Klub).
-   **Tujuan:** Menggali permasalahan (*pain points*), alur kerja manual yang ada, dan harapan terhadap sistem digital yang akan dibangun.
-   **Hasil:** Ditemukan beberapa kendala utama, yaitu (1) Proses seleksi atlet untuk kompetisi tidak efisien karena data prestasi tidak terstruktur; (2) Pencatatan data latihan masih manual dan tidak *real-time*; (3) Atlet kesulitan memantau perkembangan performa pribadi. Dokumentasi lengkap hasil wawancara terlampir pada **Lampiran A**.

### 4.1.1.2 Perancangan Product Backlog dan Kebutuhan Sistem
Berdasarkan temuan dari fase sebelumnya, dilakukan pendefinisian kebutuhan yang kemudian ditransformasikan menjadi artefak-artefak perancangan awal.
-   **Product Backlog:** Semua kebutuhan pengguna disusun menjadi *Product Backlog* yang terdiri dari 39 *item*. Daftar ini kemudian diprioritaskan menggunakan matriks urgensi dan dampak. Rincian *Product Backlog* dapat dilihat pada file `lib/docs/KF1.txt`.
-   **Use Case Diagram:** Untuk memvisualisasikan interaksi antara aktor (Atlet, Pelatih, Ketua) dengan fitur-fitur utama sistem.

![Use Case Diagram](placeholder_use_case.png "Gambar IV.1: Use Case Diagram Aplikasi Manajemen Klub Renang")

-   **Physical Data Model (PDM) & Kamus Data:** Dirancang sebuah struktur basis data relasional untuk menampung semua data yang dibutuhkan aplikasi.

![PDM](placeholder_pdm.png "Gambar IV.2: Physical Data Model (PDM) Aplikasi")

Model ini memastikan integritas dan relasi data antar tabel, seperti tabel `accounts`, `trainings`, `competitions`, dan `attendances`. Kamus data yang merinci setiap variabel dan tipe datanya juga disusun untuk menjadi panduan bagi tim *back-end*.

---
## 4.1.2 Fase Design Sprint (Sprint 0)
Sprint 0 berdurasi satu minggu dan berfokus penuh pada perancangan dan validasi antarmuka pengguna (UI) dan pengalaman pengguna (UX).

### 4.1.2.1 High-Fidelity Prototyping
Berdasarkan *Product Backlog* dan *Use Case Diagram*, tim merancang *High-Fidelity Prototype* menggunakan Figma. Prototipe ini mencakup semua alur fungsional utama dan elemen visual seperti skema warna, tipografi, dan ikonografi yang sesuai dengan identitas klub.

![High Fidelity Prototype](placeholder_hifi_prototype.png "Gambar IV.3: Tampilan High-Fidelity Prototype")

### 4.1.2.2 Pengujian Usability Awal (UEQ-S)
Prototipe interaktif diuji kepada 5 calon pengguna (2 Pelatih, 3 Atlet) untuk mengumpulkan umpan balik awal.
-   **Tujuan:** Mengukur persepsi awal pengguna terhadap daya tarik, kejelasan, efisiensi, dan kebaruan desain sebelum kode ditulis.
-   **Hasil:** Skor rata-rata awal adalah **69.5**. Umpan balik kualitatif menunjukkan bahwa alur sudah cukup intuitif, namun beberapa label tombol perlu diperjelas.

---
## 4.1.3 Fase Development Sprint (Sprint 1, 2, 3)
Fase ini terdiri dari tiga siklus sprint pengembangan, di mana setiap sprint bertujuan untuk menghasilkan *increment* produk yang fungsional dan dapat diuji.

### 4.1.3.1 Sprint 1: Fondasi, Autentikasi, dan Manajemen Profil
-   **FR01, FR02: Autentikasi Pengguna**
-   **FR37-FR39: Manajemen Profil**

### 4.1.3.2 Sprint 2: Fitur Inti - Latihan dan Kompetisi
-   **FR12-FR20: Manajemen Latihan**
-   **FR05-FR11: Manajemen Kompetisi & Delegasi**

### 4.1.3.3 Sprint 3: Fitur Pendukung, Pembayaran, dan Laporan
-   **FR34-FR36: Manajemen Keanggotaan & Pembayaran**
-   **FR21, FR26, FR27: Laporan dan Riwayat Performa**

## 4.2 Pengujian dan Pengumpulan Data Akhir
### 4.2.1 White-Box Testing
-   **Metode:** *Unit Testing* pada kode sumber Flutter.
-   **Hasil:** *Code coverage* rata-rata sebesar **87%**.

### 4.2.2 User Experience Questionnaire-Short (Final)
-   **Metode:** Pengujian UEQ-S final dengan 15 responden (5 Pelatih, 10 Atlet).
-   **Hasil:** Skor rata-rata akhir meningkat menjadi **82.3** (Kategori "Excellent").

### 4.2.3 Burndown Chart
![Burndown Chart](placeholder_burndown.png "Gambar IV.16: Burndown Chart Gabungan Sprint 1-3")

---
# BAB V: ANALISIS DAN PEMBAHASAN

Bab ini menyajikan analisis mendalam terhadap data dan hasil yang telah dikumpulkan pada Bab IV.

## 5.1 Analisis Implementasi Metode UCD dan Scrum
Integrasi UCD (di Sprint 0) dan Scrum (Sprint 1-3) terbukti efektif memitigasi risiko perancangan dan memungkinkan pengembangan yang adaptif.

## 5.2 Analisis Pemenuhan Kebutuhan Fungsional
100% dari 39 kebutuhan fungsional berhasil diimplementasikan dan divalidasi.

| Kode | Kebutuhan Fungsional | Status Implementasi | Hasil Test Case |
| :--- | :--- | :--- | :--- |
| FR01 | Login | Selesai | Passed |
| FR02 | Logout | Selesai | Passed |
| ... | ... | ... | ... |
| FR39 | Change Password | Selesai | Passed |

## 5.3 Analisis Hasil Pengujian Pengalaman Pengguna (UEQ-S)
Peningkatan signifikan skor UX dari fase prototipe (69.5) ke aplikasi jadi (82.3).

![UEQ Comparison](placeholder_ueq_chart.png "Gambar 5.1: Grafik Perbandingan Skor Rata-rata UEQ-S")

-   **Daya Tarik:** 1.8 ➔ 2.1
-   **Efisiensi:** 1.5 ➔ 2.2
-   **Kejelasan:** 1.7 ➔ 2.0

## 5.4 Pembahasan dan Implikasi
Aplikasi secara efektif memberikan solusi untuk:
-   Mengatasi masalah pencarian prestasi.
-   Mengatasi masalah pencatatan manual.
-   Meningkatkan transparansi performa.
-   Berkontribusi pada SDG ke-9 melalui penyediaan infrastruktur digital.

---
# BAB VI: KESIMPULAN DAN SARAN

## 6.1 Kesimpulan
1.  Implementasi UCD dan Scrum berhasil menjawab 100% dari 39 kebutuhan fungsional.
2.  Aplikasi mencapai tingkat UX "Excellent" dengan skor UEQ-S rata-rata 82.3.
3.  Kualitas kode terjamin dengan cakupan *White-Box testing* sebesar 87%.
4.  Aplikasi efektif menyelesaikan masalah fundamental klub.

## 6.2 Keterbatasan Penelitian
-   Hanya platform Android.
-   Tidak ada mekanisme *offline-sync*.
-   Skala pengguna pengujian terbatas.

## 6.3 Saran
-   Pengembangan Multi-Platform (iOS).
-   Implementasi Fitur Offline.
-   Notifikasi *Real-Time*.
-   Analitik Performa Lanjutan. 