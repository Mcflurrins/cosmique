# PWS Deployment Site:
<details>  
<summary>WEEK 5</summary>

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

### Explain the difference between const and final keyword.

### Explain how you implemented the checklist above step-by-step.

</details>
