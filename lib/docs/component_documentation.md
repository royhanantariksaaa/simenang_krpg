# Dokumentasi Komponen Aplikasi KRPG

Dokumen ini menyediakan ringkasan dari semua komponen (widget) kustom yang digunakan dalam aplikasi "SiMenang KRPG". Komponen-komponen ini dibangun untuk memastikan konsistensi tampilan dan fungsionalitas di seluruh aplikasi.

## Daftar Isi
1.  [Layout](#1-layout)
2.  [Buttons](#2-buttons)
3.  [Cards](#3-cards)
4.  [Forms](#4-forms)
5.  [UI (User Interface)](#5-ui)

---

## 1. Layout
Komponen layout adalah blok bangunan dasar untuk struktur visual dari setiap halaman aplikasi.

### `krpg_app_bar.dart`
-   **Deskripsi:** Widget `AppBar` kustom yang digunakan secara konsisten di seluruh aplikasi. Menampilkan judul halaman dan tombol aksi seperti kembali (back) atau menu.
-   **Properti Utama:** `title`, `actions`, `showBackButton`.

### `krpg_navbar.dart`
-   **Deskripsi:** `NavigationBar` bawah yang menyediakan navigasi utama antar-layar utama aplikasi, seperti Beranda, Latihan, Kompetisi, dan Profil.
-   **Properti Utama:** `selectedIndex`, `onItemTapped`.

### `krpg_scaffold.dart`
-   **Deskripsi:** Sebuah *wrapper* untuk `Scaffold` bawaan Flutter. Menggabungkan `krpg_app_bar` dan `krpg_navbar` untuk menciptakan struktur halaman yang seragam. Ini menyederhanakan pembuatan halaman baru.
-   **Properti Utama:** `body`, `appBarTitle`, `bottomNavBar`.

### `krpg_tab_bar.dart`
-   **Deskripsi:** Komponen untuk membuat tampilan tab di dalam sebuah halaman. Berguna untuk memisahkan konten yang saling terkait, seperti "Detail Latihan" dan "Peserta".
-   **Properti Utama:** `tabs` (daftar judul tab), `tabViews` (daftar widget untuk setiap tab).

---

## 2. Buttons
Komponen tombol menyediakan interaksi standar untuk pengguna.

### `krpg_button.dart`
-   **Deskripsi:** Tombol serbaguna dengan beberapa varian gaya (misalnya, *primary*, *secondary*, *destructive*). Tombol ini digunakan untuk semua aksi utama dalam aplikasi untuk menjaga konsistensi.
-   **Properti Utama:** `label`, `onPressed`, `type` (enum untuk gaya), `isLoading`.

---

## 3. Cards
Kartu digunakan untuk menampilkan ringkasan informasi yang ringkas dan mudah dibaca.

### `krpg_card.dart`
-   **Deskripsi:** Komponen kartu dasar dengan *shadow* dan *border radius* standar. Semua kartu lain dalam aplikasi merupakan turunan atau variasi dari kartu ini.
-   **Properti Utama:** `child`, `padding`, `margin`.

### Varian Kartu Spesifik:
-   `athlete_card.dart`: Menampilkan ringkasan info seorang atlet (nama, foto, kelas).
-   `attendance_card.dart`: Menampilkan status kehadiran untuk satu sesi.
-   `classroom_card.dart`: Menampilkan informasi tentang sebuah kelas latihan.
-   `coach_card.dart`: Menampilkan ringkasan info seorang pelatih.
-   `competition_card.dart`: Menampilkan jadwal atau hasil sebuah kompetisi.
-   `competition_certificate_card.dart`: Menampilkan sertifikat yang diraih dari kompetisi.
-   `competition_result_card.dart`: Menampilkan hasil spesifik dari sebuah kompetisi.
-   `health_data_card.dart`: Menampilkan data kesehatan ringkas.
-   `invoice_card.dart`: Menampilkan detail tagihan atau pembayaran.
-   `location_card.dart`: Menampilkan informasi terkait lokasi.
-   `profile_management_card.dart`: Kartu yang berisi aksi terkait manajemen profil.
-   `training_card.dart`: Menampilkan jadwal atau ringkasan sesi latihan.
-   `training_phase_card.dart`: Menampilkan fase-fase dalam sebuah program latihan.
-   `training_session_card.dart`: Menampilkan detail sesi latihan yang sedang atau telah berlangsung.
-   `training_statistics_card.dart`: Menampilkan statistik dari satu atau lebih sesi latihan.

### Varian Kartu Detail:
Varian `detailed_` dari kartu di atas (misalnya, `detailed_competition_result_card.dart`) digunakan pada halaman detail untuk menampilkan informasi yang lebih lengkap dibandingkan kartu ringkasannya.

---

## 4. Forms
Komponen form digunakan untuk mengumpulkan input dari pengguna.

### `krpg_form_field.dart`
-   **Deskripsi:** *Wrapper* untuk `TextFormField` yang telah disesuaikan dengan gaya desain aplikasi. Dilengkapi dengan label, ikon, dan validasi standar.
-   **Properti Utama:** `controller`, `labelText`, `validator`, `prefixIcon`.

### `krpg_dropdown.dart`
-   **Deskripsi:** Komponen `DropdownButtonFormField` kustom untuk memilih satu opsi dari daftar.
-   **Properti Utama:** `items`, `value`, `onChanged`, `hintText`.

### `krpg_search_bar.dart`
-   **Deskripsi:** Komponen bar pencarian yang konsisten. Dilengkapi dengan logika untuk *debouncing* (menunda aksi pencarian sesaat setelah pengguna berhenti mengetik) untuk efisiensi.
-   **Properti Utama:** `onChanged`, `hintText`, `controller`.

---

## 5. UI (User Interface)
Komponen UI lainnya yang mendukung tampilan aplikasi.

### `krpg_badge.dart`
-   **Deskripsi:** Sebuah label kecil berwarna untuk menampilkan status atau kategori. Contohnya: status "Aktif", "Selesai", atau level kompetisi "Nasional".
-   **Properti Utama:** `text`, `color`.

### `dummy_data_indicator.dart`
-   **Deskripsi:** Sebuah *banner* atau indikator visual yang ditampilkan di atas layar untuk menandakan bahwa data yang sedang ditampilkan adalah data dummy atau mode pengembangan. Sangat berguna selama proses development dan testing.
-   **Properti Utama:** `isEnabled`. 