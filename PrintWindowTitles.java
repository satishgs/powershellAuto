import com.hp.lft.sdk.*;
import com.hp.lft.sdk.java.*;

import java.util.List;

public class PrintWindowTitles {
    public static void main(String[] args) {
        try {
            // Describe a generic JavaWindow object
            JavaWindow genericWindow = new JavaWindow();

            // Get a list of all top-level Java windows
            List<JavaWindow> windows = genericWindow.getTopLevelWindows();

            // Loop through the list and print out the title of each window
            for (JavaWindow window : windows) {
                System.out.println("Window title: " + window.getWindowTitle());
            }

        } catch (GeneralLeanFtException e) {
            e.printStackTrace();
        }
    }
}
