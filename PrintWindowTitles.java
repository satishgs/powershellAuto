import com.hp.lft.sdk.*;
import com.hp.lft.sdk.java.*;

import java.util.List;

public class PrintWindowTitles {
    public static void main(String[] args) {
        try {
            // Get a list of all open windows
            List<Window> windows = Desktop.getDesktop().getWindows();

            // Loop through the list and print out the title of each window
            for (Window window : windows) {
                System.out.println("Window title: " + window.getWindowTitle());
            }

        } catch (GeneralLeanFtException e) {
            e.printStackTrace();
        }
    }
}
