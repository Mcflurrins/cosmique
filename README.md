# Flutter Assignment
<details>  
<summary>WEEK 6</summary>

### Explain what are stateless widgets and stateful widgets, and explain the difference between them.
Stateful widgets make up parts of the Flutter application's user interface which are more dynamic and can change its appearance in response to events triggered by user interactions or when it receives data. The widget's State is then stored in a State object to separate the widget's state from its appearance, and this State consists of values that can change. Example: Slider, Form. Stateless widgets on the other hand, are static and do not have changes in state. While they may change in appearance ever so slightly, they do not have a separately stored State object that allows them to be dynamic. Example: Icon, Text.

### Mention the widgets that you have used for this project and its uses. 
1. MaterialApp: Wraps the entire application and provides necessary material design functionality like theming, navigation, and localization.
2. Material: A widget that introduces the Material Design visual style, giving widgets like buttons and text fields their material appearance like elevation effects, shadows.
3. InkWell: A rectangular area that responds to touch, often used to wrap other widgets like buttons or images to make them tappable with ripple effects on touch.
4. Scaffold: Provides a basic layout structure for the visual interface of the screen, including standard elements like an app bar, body, floating action button, bottom navigation, and drawers.
5. AppBar: A material design app bar that typically holds titles, icons, and actions at the top of a screen, often used inside a Scaffold.
6. SnackBar: A lightweight message bar that briefly shows messages at the bottom of the screen, often used to inform users about the result of actions they’ve taken.
7. SingleChildScrollView: A scrollable widget that allows its single child to scroll vertically or horizontally, useful when the content might not fit on a single screen.
8. SizedBox: A box with a fixed size, often used to add space between widgets or to define specific dimensions for a widget.
9. Column: A layout widget that arranges its children vertically, useful for stacking widgets in a vertical direction.
10. GridView: A scrollable, 2D array of widgets, useful for displaying a large number of items (like images or icons) in a grid format.
11. Padding: A widget that insets its child by the specified padding values on each side, used to control spacing around a widget.
12. Text: A widget that displays a string of text with a customizable style.
13. Icon: A widget that displays a graphical symbol from the material design library or other icon sets.

### What is the use-case for setState()? Explain the variable that can be affected by setState().
The setState() method in Flutter is used within stateful widgets to trigger a UI rebuild when the widget's state changes. It updates variables that affect the UI, such as counters, colors, or text, by marking the widget tree for redrawing. Typically, it is used to modify state variables (defined within the State class) in response to user interactions or other dynamic events, ensuring the UI reflects the updated values. However, only the logic for updating the state should go inside setState(), and it should not be used for long-running tasks.

### Explain the difference between const and final keyword.
The const keyword declares compile time constants, while the final keyword declares run time constants. This means that a variable declared with the const keyword is initialized at compile-time and is already assigned a value by the time the program runs, while a variable declared with the final keyword is initialized at run-time and can only be assigned for a single time after the program runs. For example, you can use final when you don't know what the value of a variable is during compile-time, like when you need to store data from an API in a variable, this only happens when your code is already running.

### Explain how you implemented the checklist above step-by-step.
```
flutter create cosmmique
cd cosmique
```

```
import 'package:flutter/material.dart';
```

```
import 'package:flutter/material.dart';
import 'package:cosmique/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
       primarySwatch: Colors.grey,
 ).copyWith(secondary: Colors.grey[900]),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
```

```

class ItemCard extends StatelessWidget {
  // Display the card with an icon and name.

  final ItemHomepage item; 
  
  const ItemCard(this.item, {super.key}); 

  @override
  Widget build(BuildContext context) {
    return Material(
      // Specify the background color of the application theme.
      color: item.iconColor,
      // Round the card border.
      borderRadius: BorderRadius.circular(12),
      
      child: InkWell(
        // Action when the card is pressed.
        onTap: () {
          // Display the SnackBar message when the card is pressed.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You have pressed the ${item.name} button!"))
            );
        },
        // Container to store the Icon and Text
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              // Place the Icon and Text in the center of the card.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

```
class ItemHomepage {
     final String name;
     final IconData icon;
     final Color iconColor;

     ItemHomepage(this.name, this.icon, this.iconColor);
 }
```

```
class InfoCard extends StatelessWidget {
  // Card information that displays the title and content.

  final String title;  // Card title.
  final String content;  // Card content.

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Create a card box with a shadow.
      elevation: 2.0,
      child: Container(
        // Set the size and spacing within the card.
        width: MediaQuery.of(context).size.width / 3.5, // Adjust with the width of the device used.
        padding: const EdgeInsets.all(16.0),
        // Place the title and content vertically.
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

```

```
import 'package:flutter/material.dart';
class MyHomePage extends StatelessWidget {
  final String npm = '2306171713'; // NPM
  final String name = 'Flori Andrea Ng'; // Name
  final String className = 'KKI'; // Class
  final List<ItemHomepage> items = [
         ItemHomepage("View Product", Icons.mood, Colors.lightBlue),
         ItemHomepage("Add Product", Icons.add, Colors.orange),
         ItemHomepage("Logout", Icons.logout, Colors.pink),
     ];
  MyHomePage({super.key});

    @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of the page with the AppBar and body.
    return Scaffold(
      // AppBar is the top part of the page that displays the title.
      appBar: AppBar(
        // The title of the application "Mental Health Tracker" with white text and bold font.
        title: const Text(
          'COSMIQUE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // The background color of the AppBar is obtained from the application theme color scheme.
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      // Body of the page with paddings around it.
      body: SingleChildScrollView( 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Place the widget vertically in a column.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row to display 3 InfoCard horizontally.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
              ],
            ),

            // Give a vertical space of 16 units.
            const SizedBox(height: 16.0),

            // Place the following widget in the center of the page.
            Center(
              child: Column(
                // Place the text and grid item vertically.

                children: [
                  // Display the welcome message with bold font and size 18.
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to COSMIQUE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // Grid to display ItemCard in a 3 column grid.
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    // To ensure that the grid fits its height.
                    shrinkWrap: true,

                    // Display ItemCard for each item in the items list.
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],       
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
```
</details>
