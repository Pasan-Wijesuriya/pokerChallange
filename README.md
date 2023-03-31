# pokerChallange
Argenti - Poker Challange

Open Xcode on your Mac.
In the menu bar, click on File -> New -> Playground.
In the New Playground dialog box, choose a name and location for your playground, and then click on the “Create” button.
Once the playground opens, you will see a blank editor area where you can start writing your code.
Copy and paste the code you want to run into the editor.
Press the "Run" button in the bottom left corner of the Xcode window or use the shortcut "CMD+R".
Xcode will compile and run your code in the Playground.
You should see the output of your code in the right-hand panel of the Xcode window. If there are any errors, you will see them in this panel as well.

Please add the poker-hands.txt file into your resources ->

To add the poker-hands.txt file to the resources of a Swift playground, follow these steps:
	1	Open the playground in Xcode.
	2	In the project navigator, select the playground file you want to add the file to.
	3	In the Editor menu, select "Add files to 'PlaygroundName'..."
	4	In the file picker dialog that appears, navigate to the directory containing the poker-hands.txt file and select it.
	5	Make sure the "Copy items if needed" option is selected, and click "Add".
After following these steps, the poker-hands.txt file should be added to the resources of your Swift playground, and you should be able to access it in your code using the Bundle.main.path(forResource: "poker-hands", ofType: "txt") and String(contentsOfFile: path) methods.

It will read the hands from the text file.

Run the program using the Play button on the playground

ENJOY!!

