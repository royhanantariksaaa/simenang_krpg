const KRPG_ACTIVITY_DIAGRAMS = {
  authFlow: `'Alur Autentikasi (FR01, FR02)' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Membuka aplikasi;
        (Sistem) Menampilkan halaman Login;
        (Pengguna) Memasukkan email & password, lalu tekan Login;
        (Sistem) Mengirim request login ke API;
        (API) Memvalidasi kredensial pengguna;
        <API> Apakah kredensial valid? {
            -Ya- {
                (API) Mengembalikan token sesi dan data pengguna;
                (Sistem) Menyimpan token sesi;
                (Sistem) Arahkan ke Halaman Utama (Dashboard);
                // Pengguna sekarang bisa logout
                (Pengguna) Menekan tombol Logout dari menu;
                (Sistem) Menghapus sesi dan token tersimpan;
                (Sistem) Arahkan kembali ke Halaman Login;
            }
            -Tidak- {
                (API) Mengembalikan pesan error;
                (Sistem) Menampilkan pesan error login;
            }
        }
        >Sistem<;
        @Pengguna@
    }
}`,

  profileFlow: `'Alur Manajemen Profil (FR44, FR46, FR47)' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Mengakses halaman Profil;
        (Sistem) Meminta data profil dari API;
        (API) Mengembalikan data profil pengguna saat ini;
        (Sistem) Menampilkan informasi profil;
        <Pengguna> Apa yang ingin diubah? {
            -Ubah Foto Profil (FR46)- {
                (Pengguna) Memilih untuk mengunggah foto baru;
                (Sistem) Menampilkan pilihan galeri/kamera;
                (Pengguna) Mengunggah foto;
                (Sistem) Mengirim foto ke API;
                (API) Menyimpan foto dan memperbarui URL profil;
            }
            -Ubah Password (FR47)- {
                (Pengguna) Memilih untuk mengubah password;
                (Sistem) Menampilkan form ganti password;
                (Pengguna) Memasukkan password lama dan baru;
                (Sistem) Mengirim request ganti password ke API;
                (API) Memvalidasi dan mengubah password;
            }
        }
        >Sistem<;
        (Sistem) Menampilkan pesan sukses dan memperbarui tampilan;
        @Pengguna@
    }
}`,

  dashboardFlow: `'Alur Dasbor Utama (FR04, FR05)' {
    |Pengguna, Sistem, API| {
        $Sistem$
        (Sistem) Meminta data dasbor (statistik, jadwal) dari API;
        (API) Mengambil data dari database;
        (API) Mengembalikan data dasbor;
        (Sistem) Menampilkan ringkasan di halaman utama;
        (Pengguna) Melakukan aksi 'refresh' (tarik ke bawah);
        (Sistem) Meminta pembaruan data dari API (FR05);
        @Pengguna@
    }
}`,

  viewCompetitionsFlow: `'Alur Melihat Daftar Kompetisi (FR06, FR07, FR08, FR09)' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Mengakses menu Kompetisi;
        (Sistem) Meminta daftar kompetisi dari API;
        (API) Mengembalikan daftar kompetisi;
        (Sistem) Menampilkan daftar kompetisi (FR06);
        (Pengguna) Menggunakan fitur Cari (FR07) atau Filter (FR08);
        (Sistem) Mengirim request baru dengan parameter pencarian/filter;
        (API) Mengembalikan daftar kompetisi yang sesuai;
        (Sistem) Memperbarui tampilan daftar;
        (Pengguna) Memilih salah satu kompetisi;
        (Sistem) Meminta detail kompetisi dari API;
        (API) Mengembalikan detail kompetisi;
        (Sistem) Menampilkan halaman Detail Kompetisi (FR09);
        @Pengguna@
    }
}`,

  competitionDelegationFlow: `'Alur Delegasi Atlet oleh Pelatih & Ketua (FR11, FR12)' {
    |Pelatih, Sistem, API, Ketua| {
        $Pelatih$
        (Pelatih) Di halaman detail kompetisi, menekan 'Delegasikan Atlet';
        (Sistem) Menampilkan daftar atlet yang bisa didelegasikan;
        (Pelatih) Memilih atlet dan mengirimkan permintaan;
        (Sistem) Mengirim request delegasi ke API;
        (API) Menyimpan permintaan dengan status 'Menunggu Persetujuan';
        (Sistem) Mengirim notifikasi ke Ketua;
        (Ketua) Membuka daftar permintaan delegasi;
        (Sistem) Menampilkan permintaan dari Pelatih;
        (Ketua) Meninjau permintaan;
        <Ketua> Setujui permintaan? {
            -Ya (FR11)- {
                (Ketua) Menekan tombol 'Setujui';
                (Sistem) Mengirim pembaruan status ke API;
                (API) Mengubah status delegasi menjadi 'Disetujui';
                (Sistem) Mengirim notifikasi ke Pelatih;
            }
            -Tidak (FR12)- {
                (Ketua) Menekan tombol 'Tolak';
                (Sistem) Mengirim pembaruan status ke API;
                (API) Mengubah status delegasi menjadi 'Ditolak';
                (Sistem) Mengirim notifikasi ke Pelatih;
            }
        }
        >Ketua<;
        @Ketua@
    }
}`,

  coachTrainingFlow: `'Alur Manajemen Latihan (Pelatih) (FR14-FR23)' {
    |Pelatih, Sistem, API| {
        $Pelatih$
        (Pelatih) Mengakses menu Latihan;
        (Sistem) Menampilkan daftar jadwal latihan (FR14);
        (Pelatih) Memilih jadwal latihan untuk dimulai;
        (Sistem) Menampilkan detail latihan (FR17);
        (Pelatih) Menekan 'Mulai Sesi Latihan' (FR18);
        (Sistem) Mencatat kehadiran pelatih (FR29);
        (Sistem) Menampilkan layar sesi live;
        (Pelatih) Memantau kehadiran atlet yang masuk;
        (Pelatih) Memilih atlet untuk dicatat waktunya;
        (Sistem) Menyediakan antarmuka Stopwatch/Timer (FR22, FR23);
        (Pelatih) Mencatat data performa atlet (FR21);
        (Sistem) Mengirim data performa ke API;
        (API) Menyimpan catatan performa;
        <Pelatih> Lanjut mencatat atau akhiri sesi? {
            -Lanjut- {
                (Pelatih) Kembali memilih atlet lain;
            }
            -Akhiri Sesi (FR19)- {
                (Pelatih) Menekan tombol 'Akhiri Sesi';
                (Sistem) Mengirim data final sesi ke API;
                (API) Menutup sesi latihan;
                (Sistem) Menampilkan ringkasan sesi;
            }
        }
        >Pelatih<;
        @Pelatih@
    }
}`,

  athleteAttendanceFlow: `'Alur Kehadiran Latihan (Atlet) (FR20, FR26, FR30)' {
    |Atlet, Sistem, API| {
        $Atlet$
        (Atlet) Membuka jadwal latihan yang akan diikuti;
        (Sistem) Menampilkan tombol 'Lakukan Presensi';
        (Atlet) Menekan tombol 'Lakukan Presensi' (FR20);
        (Sistem) Mengambil lokasi GPS perangkat;
        (Sistem) Mengirim koordinat lokasi ke API untuk validasi;
        (API) Membandingkan lokasi dengan koordinat tempat latihan;
        <API> Apakah lokasi valid (FR30)? {
            -Ya- {
                (API) Mencatat kehadiran atlet;
                (Sistem) Menampilkan pesan presensi berhasil;
                (Atlet) Dapat melihat riwayat kehadirannya (FR26);
            }
            -Tidak- {
                (API) Mengembalikan pesan error;
                (Sistem) Menampilkan pesan 'Lokasi di luar jangkauan';
            }
        }
        >Sistem<;
        @Atlet@
    }
}`,

  viewPerformanceFlow: `'Alur Melihat Performa & Statistik (FR31, FR32, FR35)' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Mengakses halaman detail (atlet atau latihan);
        (Pengguna) Memilih tab 'Performa' atau 'Statistik';
        (Sistem) Meminta data histori performa dari API (FR31, FR32);
        (Pengguna) Menggunakan filter rentang waktu (FR35);
        (Sistem) Mengirim request baru dengan filter;
        (API) Mengambil dan mengolah data dari database;
        (API) Mengembalikan data statistik;
        (Sistem) Menampilkan data dalam bentuk grafik dan tabel;
        @Pengguna@
    }
}`,

  viewAthletesFlow: `'Alur Melihat & Mengelola Atlet (Pelatih) (FR36-FR39)' {
    |Pelatih, Sistem, API| {
        $Pelatih$
        (Pelatih) Mengakses menu 'Manajemen Atlet';
        (Sistem) Meminta daftar semua atlet dari API (FR36);
        (API) Mengembalikan daftar atlet;
        (Sistem) Menampilkan daftar atlet;
        (Pelatih) Menggunakan fitur Cari (FR37) atau Filter (FR38);
        (Sistem) Meminta data yang difilter ke API;
        (API) Mengembalikan daftar yang sesuai;
        (Sistem) Memperbarui tampilan daftar;
        (Pelatih) Memilih satu atlet untuk melihat detail;
        (Sistem) Menampilkan halaman detail atlet (FR39);
        @Pelatih@
    }
}`,

  membershipPaymentFlow: `'Alur Keanggotaan & Pembayaran (Atlet) (FR40, FR41, FR42)' {
    |Atlet, Sistem, API| {
        $Atlet$
        (Atlet) Mengakses menu 'Keanggotaan';
        (Sistem) Meminta status dan riwayat pembayaran dari API;
        (API) Mengembalikan data pembayaran;
        (Sistem) Menampilkan status keanggotaan (FR40) dan riwayat (FR42);
        (Atlet) Menekan tombol 'Unggah Bukti Pembayaran' (FR41);
        (Sistem) Menampilkan form unggah;
        (Atlet) Memilih file bukti bayar dan mengirimkannya;
        (Sistem) Mengunggah file ke API;
        (API) Menyimpan file dan mengubah status pembayaran menjadi 'Menunggu Verifikasi';
        (Sistem) Menampilkan pesan sukses;
        @Atlet@
    }
}`
}; 