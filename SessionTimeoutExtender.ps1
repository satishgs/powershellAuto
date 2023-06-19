# Import the required assemblies
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class MouseMover {
        [DllImport("user32.dll")]
        public static extern bool SetCursorPos(int X, int Y);
    }
"@

# Function to move the mouse cursor
function Move-MouseCursor {
    $currentCursorPosition = [System.Windows.Forms.Cursor]::Position
    [MouseMover]::SetCursorPos($currentCursorPosition.X + 1, $currentCursorPosition.Y)
    [MouseMover]::SetCursorPos($currentCursorPosition.X, $currentCursorPosition.Y)
}

# Main script
while ($true) {
    Move-MouseCursor
    Start-Sleep -Seconds 60
}
