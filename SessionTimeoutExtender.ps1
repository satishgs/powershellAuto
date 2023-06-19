# Import the required assemblies
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class MouseMover {
        [StructLayout(LayoutKind.Sequential)]
        public struct INPUT
        {
            public uint type;
            public MOUSEINPUT mi;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public uint mouseData;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [DllImport("user32.dll", SetLastError = true)]
        public static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        public static void MoveMouse()
        {
            INPUT[] inputs = new INPUT[1];
            inputs[0].type = 0;  // INPUT_MOUSE
            inputs[0].mi.dx = 1;
            inputs[0].mi.dy = 1;
            inputs[0].mi.mouseData = 0;
            inputs[0].mi.dwFlags = 0x0001;  // MOUSEEVENTF_MOVE
            inputs[0].mi.time = 0;
            inputs[0].mi.dwExtraInfo = IntPtr.Zero;

            SendInput(1, inputs, Marshal.SizeOf(typeof(INPUT)));
        }
    }
"@

# Main script
while ($true) {
    [MouseMover]::MoveMouse()
    Start-Sleep -Seconds 60
}
