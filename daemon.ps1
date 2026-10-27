Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
    int _0(); int _1(); int _2(); int _3();
    int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
    int _5(); int _6(); int _7();
    int GetMasterVolumeLevelScalar(out float pfLevel);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
    int Activate(ref System.Guid iid, int dwClsCtx, System.IntPtr pActivationParams, out IAudioEndpointVolume ppInterface);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
    int _0();
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice ppDevice);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
class MMDeviceEnumeratorComObject { }
public class Audio {
    static IAudioEndpointVolume _vol;
    static Audio() {
        var enumerator = (IMMDeviceEnumerator)(new MMDeviceEnumeratorComObject());
        IMMDevice dev; enumerator.GetDefaultAudioEndpoint(0, 1, out dev);
        var iid = typeof(IAudioEndpointVolume).GUID;
        dev.Activate(ref iid, 1, System.IntPtr.Zero, out _vol);
    }
    public static void Max() { _vol.SetMasterVolumeLevelScalar(1.0f, System.Guid.Empty); }
}
"@

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sound = Join-Path $dir "sound.mp3"

while ($true) {
    $mp = New-Object System.Windows.Controls.MediaElement
    $mp.Source = New-Object System.Uri ($sound)
    $mp.LoadedBehavior = "Manual"
    $mp.UnloadedBehavior = "Manual"
    $mp.Volume = 1
    $mp.MediaEnded += { $mp.Position = [TimeSpan]::Zero; $mp.Play() }
    
    $w = New-Object System.Windows.Window
    $w.WindowStyle = "None"
    $w.Width = 1
    $w.Height = 1
    $w.Left = -100
    $w.Top = -100
    $w.ShowInTaskbar = $false
    $w.Content = $mp
    $w.Show()
    $mp.Play()

    $end = (Get-Date).AddSeconds(561)
    while ((Get-Date) -lt $end) { 
        [Audio]::Max()
        Start-Sleep -Milliseconds 300 
    }
    
    $mp.Stop()
    $w.Close()
    
    Start-Sleep -Seconds 60
}