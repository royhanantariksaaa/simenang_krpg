const KRPG_SIMPLE_ACTIVITY_DIAGRAMS = {
  // --- AUTHENTICATION (FR01, FR02) ---
  loginFlow: `'FR01: Login Pengguna' {
    |Pengguna, Sistem, API| {
      $Pengguna$
      (Pengguna) Membuka aplikasi, melihat Halaman Login;
      (Pengguna) Memasukkan email dan password;
      (Pengguna) Menekan tombol 'Login';
      (Sistem) Mengirim request ke API;
      (API) Memvalidasi kredensial;
      <API> Kredensial Valid? {
        -Ya- {
          (API) Mengembalikan token & data pengguna;
          (Sistem) Menyimpan sesi & mengarahkan ke Dashboard;
        }
        -Tidak- {
          (API) Mengembalikan error;
          (Sistem) Menampilkan pesan error;
        }
      }
      >Sistem<;
      @Pengguna@
    }
  }`,

  logoutFlow: `'FR02: Logout Pengguna' {
    |Pengguna, Sistem| {
      $Pengguna$
      (Pengguna) Berada di dalam aplikasi (sudah login);
      (Pengguna) Menekan tombol 'Logout' dari menu;
      (Sistem) Menghapus data sesi yang tersimpan;
      (Sistem) Mengarahkan kembali ke Halaman Login;
      @Pengguna@
    }
  }`,

  // --- DASHBOARD (FR04, FR05) ---
  viewDashboardFlow: `'FR04 & FR05: Melihat & Refresh Dashboard' {
    |Pengguna, Sistem, API| {
      $Sistem$
      (Sistem) Meminta data utama dari API saat login berhasil;
      (API) Mengembalikan data ringkasan;
      (Sistem) Menampilkan data di Dashboard;
      (Pengguna) Menarik layar ke bawah untuk refresh;
      (Sistem) Meminta data terbaru dari API;
      (API) Mengembalikan data baru;
      (Sistem) Memperbarui tampilan Dashboard;
      @Pengguna@
    }
  }`,

  // --- COMPETITION (FR06-FR13) ---
  viewCompetitionListFlow: `'FR06: Melihat Daftar Kompetisi' {
    |Pengguna, Sistem, API| {
      $Pengguna$
      (Pengguna) Mengakses menu 'Kompetisi';
      (Sistem) Meminta daftar kompetisi ke API;
      (API) Mengembalikan daftar kompetisi;
      (Sistem) Menampilkan daftar kompetisi di layar;
      @Pengguna@
    }
  }`,

  searchFilterCompetitionFlow: `'FR07 & FR08: Mencari & Filter Kompetisi' {
    |Pengguna, Sistem, API| {
      $Pengguna$
      (Pengguna) Berada di halaman daftar kompetisi;
      (Pengguna) Memasukkan kata kunci di bar pencarian atau memilih filter;
      (Sistem) Mengirim request ke API dengan parameter;
      (API) Mengembalikan daftar kompetisi yang cocok;
      (Sistem) Memperbarui tampilan daftar;
      @Pengguna@
    }
  }`,

  viewCompetitionDetailFlow: `'FR09: Melihat Detail Kompetisi' {
    |Pengguna, Sistem, API| {
      $Pengguna$
      (Pengguna) Menekan salah satu item di daftar kompetisi;
      (Sistem) Meminta detail kompetisi ke API;
      (API) Mengembalikan informasi lengkap kompetisi;
      (Sistem) Menampilkan halaman detail kompetisi;
      @Pengguna@
    }
  }`,

  requestDelegationFlow: `'FR10: Pelatih Mengajukan Delegasi Atlet' {
    |Pelatih, Sistem, API| {
        $Pelatih$
        (Pelatih) Di halaman detail kompetisi, menekan 'Delegasikan Atlet';
        (Sistem) Menampilkan daftar atlet yang bisa didelegasikan;
        (Pelatih) Memilih atlet dan mengirimkan permintaan;
        (Sistem) Mengirim request delegasi ke API;
        (API) Menyimpan permintaan dengan status 'Menunggu Persetujuan';
        (Sistem) Menampilkan pesan konfirmasi;
        @Pelatih@
    }
  }`,

  approveRejectDelegationFlow: `'FR11 & FR12: Ketua Menyetujui/Menolak Delegasi' {
    |Ketua, Sistem, API| {
        $Ketua$
        (Ketua) Menerima notifikasi & membuka daftar permintaan delegasi;
        (Sistem) Menampilkan permintaan dari Pelatih;
        <Ketua> Setujui permintaan? {
            -Ya- {
                (Ketua) Menekan tombol 'Setujui';
                (Sistem) Mengirim pembaruan status 'Disetujui' ke API;
            }
            -Tidak- {
                (Ketua) Menekan tombol 'Tolak';
                (Sistem) Mengirim pembaruan status 'Ditolak' ke API;
            }
        }
        >Sistem<;
        (API) Menyimpan status baru dan mengirim notifikasi ke Pelatih;
        (Sistem) Menampilkan konfirmasi tindakan;
        @Ketua@
    }
  }`,

  // --- TRAINING (FR14-FR25) ---
  startTrainingSessionFlow: `'FR18 & FR29: Pelatih Memulai Sesi Latihan' {
    |Pelatih, Sistem, API| {
      $Pelatih$
      (Pelatih) Memilih jadwal latihan dan menekan 'Mulai Sesi';
      (Sistem) Memvalidasi apakah waktu sesuai jadwal;
      (Sistem) Secara otomatis mencatat kehadiran Pelatih (FR29);
      (Sistem) Mengirim status sesi 'aktif' ke API;
      (Sistem) Menampilkan halaman sesi latihan live;
      @Pelatih@
    }
  }`,

  endTrainingSessionFlow: `'FR19: Pelatih Mengakhiri Sesi Latihan' {
    |Pelatih, Sistem, API| {
      $Pelatih$
      (Pelatih) Berada di halaman sesi latihan live;
      (Pelatih) Menekan tombol 'Akhiri Sesi';
      (Sistem) Mengirim status sesi 'selesai' ke API;
      (API) Menutup sesi dan menghitung rekap;
      (Sistem) Menampilkan ringkasan sesi latihan;
      @Pelatih@
    }
  }`,

  athleteAttendTrainingFlow: `'FR20 & FR30: Atlet Melakukan Presensi Latihan' {
    |Atlet, Sistem, API| {
      $Atlet$
      (Atlet) Membuka jadwal latihan yang sedang aktif;
      (Atlet) Menekan 'Lakukan Presensi';
      (Sistem) Mengambil lokasi GPS dari perangkat;
      (API) Memvalidasi apakah lokasi berada dalam jangkauan;
      <API> Lokasi Valid? {
        -Ya- {
          (API) Mencatat kehadiran Atlet (FR30);
          (Sistem) Menampilkan pesan 'Presensi Berhasil';
        }
        -Tidak- {
          (Sistem) Menampilkan pesan 'Di Luar Jangkauan';
        }
      }
      >Sistem<;
      @Atlet@
    }
  }`,

  recordAthleteTrainingDataFlow: `'FR21, FR22, FR23: Mencatat Data Latihan Atlet' {
    |Pelatih, Sistem, API| {
      $Pelatih$
      (Pelatih) Di sesi live, memilih seorang atlet;
      (Sistem) Menampilkan antarmuka pencatatan (Stopwatch/Timer);
      (Pelatih) Mencatat waktu atau data lain;
      (Pelatih) Menyimpan data;
      (Sistem) Mengirim data performa atlet ke API;
      (API) Menyimpan catatan data;
      (Sistem) Menampilkan konfirmasi data tersimpan;
      @Pelatih@
    }
  }`,

  // --- PERFORMANCE & HISTORY (FR25, FR26, FR31, FR32) ---
  viewHistoryFlow: `'FR25, FR26, FR32: Melihat Riwayat (Umum)' {
    |Pengguna, Sistem, API| {
      $Pengguna$
      (Pengguna) Mengakses halaman riwayat (Latihan/Presensi/Performa);
      (Sistem) Meminta data riwayat dari API;
      (API) Mengembalikan daftar data riwayat;
      (Sistem) Menampilkan daftar dalam bentuk list atau grafik;
      @Pengguna@
    }
  }`,

  // --- MEMBERSHIP & PAYMENT (FR40, FR41, FR42) ---
  viewMembershipFlow: `'FR40 & FR42: Melihat Status & Riwayat Keanggotaan' {
    |Atlet, Sistem, API| {
      $Atlet$
      (Atlet) Mengakses menu 'Keanggotaan';
      (Sistem) Meminta data keanggotaan dari API;
      (API) Mengembalikan status aktif, tagihan, dan riwayat bayar;
      (Sistem) Menampilkan semua informasi di layar;
      @Atlet@
    }
  }`,

  uploadPaymentFlow: `'FR41: Mengunggah Bukti Pembayaran' {
    |Atlet, Sistem, API| {
      $Atlet$
      (Atlet) Di menu Keanggotaan, menekan 'Unggah Bukti Bayar';
      (Sistem) Membuka form unggah;
      (Atlet) Memilih file gambar dari galeri/kamera;
      (Sistem) Mengunggah file ke API;
      (API) Menyimpan file & mengubah status menjadi 'Menunggu Verifikasi';
      (Sistem) Menampilkan pesan 'Unggah Berhasil';
      @Atlet@
    }
  }`,

  // --- PROFILE MANAGEMENT (FR44, FR46, FR47) ---
  viewProfileFlow: `'FR44: Melihat Profil' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Mengakses halaman Profil;
        (Sistem) Meminta data profil dari API;
        (API) Mengembalikan data pengguna saat ini;
        (Sistem) Menampilkan informasi profil di layar;
        @Pengguna@
    }
  }`,
  
  uploadProfilePictureFlow: `'FR46: Mengunggah Foto Profil' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Di halaman profil, menekan ikon edit foto;
        (Sistem) Menampilkan pilihan galeri/kamera;
        (Pengguna) Memilih dan memotong gambar;
        (Sistem) Mengunggah gambar baru ke API;
        (API) Mengganti file foto profil lama;
        (Sistem) Memuat ulang gambar profil di aplikasi;
        @Pengguna@
    }
  }`,

  changePasswordFlow: `'FR47: Mengubah Password' {
    |Pengguna, Sistem, API| {
        $Pengguna$
        (Pengguna) Di halaman profil, memilih 'Ubah Password';
        (Sistem) Menampilkan form ubah password;
        (Pengguna) Memasukkan password lama dan baru;
        (Sistem) Mengirim request ke API;
        (API) Memvalidasi password lama & menyimpan yang baru;
        <API> Berhasil? {
            -Ya- { (Sistem) Menampilkan pesan sukses; }
            -Tidak- { (Sistem) Menampilkan pesan error; }
        }
        >Sistem<;
        @Pengguna@
    }
  }`
}; 