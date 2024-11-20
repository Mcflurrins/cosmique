# Flutter Assignment
## Flori Andrea Ng - 2306171713 - KKI
<details>  
<summary>WEEK 8 - Assignment 9</summary>
 
### Explain why we need to create a model to retrieve or send JSON data. Will an error occur if we don't create a model first?
In Flutter, models help map JSON data into Dart objects, making it easier to work with structured, strongly-typed data. They simplify parsing JSON responses from APIs and converting data into JSON for outgoing requests. Without models, you'd have to handle the JSON manually, which can lead to mistakes and code that is harder to maintain. While the app might not crash without a model,there might be runtime issues like type mismatches or null values because of improper data handling.

### Explain the function of the http library that you implemented for this task.
The http library is used to make network requests to communicate with the backend. It provides methods for common actions like GET, POST, PUT, and DELETE, as well as handling headers and body content for requests. In this task, the http library allows the app to send user data to the server and retrieve JSON responses. This data is then processed and used in the app's UI.

### Explain the function of CookieRequest and why it’s necessary to share the CookieRequest instance with all components in the Flutter app.
CookieRequest handles session cookies, ensuring that user authentication is consistent across the app. By sharing a single CookieRequest instance, all components automatically include cookies in their HTTP requests. This avoids the need to manage session cookies manually and ensures a seamless experience when accessing authenticated routes or actions in the app. It’s key to maintaining secure and consistent user sessions.

### Explain the mechanism of data transmission, from input to display in Flutter.
Data transmission starts when the user inputs information into the app's UI widgets. This data is sent to the backend using HTTP requests, with tools like http or CookieRequest. The backend processes the request and responds with JSON data. The app parses this JSON into Dart objects, usually with the help of models. These objects are then used to update the app’s UI, often using tools like FutureBuilder or state management solutions like Provider to display the data asynchronously.

### Explain the authentication mechanism from login, register, to logout. Start from inputting account data in Flutter to Django’s completion of the authentication process and display of the menu in Flutter.
The process begins when the user enters their credentials or registration details. These details are sent to the Django backend via a POST request using CookieRequest. Django validates the information, creates a session or token, and returns a cookie to the Flutter app. The app stores this cookie for future requests to protected routes. For logout, the app sends a request to the backend to clear the session, and the cookie is deleted locally as well. This ensures the session is terminated both on the server and in the app. Depending on the user’s authentication state, the app dynamically updates the UI, such as showing a menu for logged-in users or redirecting to a login screen for logged-out users.

### Explain how you implement the checklist above step by step! (not just following the tutorial).
#### 1. Setting Up Authentication for our Flutter app
First, I initialized a new 'authentication' app in my old Django project, and install django-cors-headers, then I register both of them to INSTALLED_APPS in the main project settings.py file. I also add corsheaders.middleware.CorsMiddleware to MIDDLEWARE in the main project settings.py file, and put 10.0.2.2 in its ALLOWED_HOSTS. I then put in functions for logging out, logging in and registering in views.py of the authentication folder, like so:
```
@csrf_exempt
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            auth_login(request, user)
            # Successful login status.
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login successful!"
                # Add other data if you want to send data to Flutter.
            }, status=200)
        else:
            return JsonResponse({
                "status": False,
                "message": "Login failed, account disabled."
            }, status=401)

    else:
        return JsonResponse({
            "status": False,
            "message": "Login failed, check email or password again."
        }, status=401)
    
@csrf_exempt
def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data['username']
        password1 = data['password1']
        password2 = data['password2']

        # Check if the passwords match
        if password1 != password2:
            return JsonResponse({
                "status": False,
                "message": "Passwords do not match."
            }, status=400)

        # Check if the username is already taken
        if User.objects.filter(username=username).exists():
            return JsonResponse({
                "status": False,
                "message": "Username already exists."
            }, status=400)

        # Create the new user
        user = User.objects.create_user(username=username, password=password1)
        user.save()

        return JsonResponse({
            "username": user.username,
            "status": 'success',
            "message": "User created successfully!"
        }, status=200)

    else:
        return JsonResponse({
            "status": False,
            "message": "Invalid request method."
        }, status=400)

@csrf_exempt
def logout(request):
    username = request.user.username

    try:
        auth_logout(request)
        return JsonResponse({
            "username": username,
            "status": True,
            "message": "Logged out successfully!"
        }, status=200)
    except:
        return JsonResponse({
        "status": False,
        "message": "Logout failed."
        }, status=401)
```
I also route the new functions in urls.py of the authentication directory: 
```
from django.urls import path
from authentication.views import login, register, logout

app_name = 'authentication'

urlpatterns = [
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('logout/', logout, name='logout'),
]
```
I also add the path, "path('auth/', include('authentication.urls'))" to my urls.py in the project folder. Then, to integrate this into flutter, I installed the packages 'provider' and 'pbp_django_auth' and put this following code in main.dart after the Widget build line:
```
return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
```
After that, I made the files login.dart and register.dart in the screens folder, and filled it with code exactly as it was given in the tutorial (I filled in the TO-DO's, but other than that I felt copy-pasting the entire code from those two files would be too lengthy and verbose to include in this answer). For logging out, I added this line to lib/widgets/product_card.dart, right after the Widget build line: 
```
final request = context.watch<CookieRequest>();
```
I changed the onTap() for the widget Inkwell into onTap: () async {...} as well so that the logout could be done asynchronously. In the end, it looks like this: 
```
child: InkWell(
        onTap: () async {
        ...
          } else if (item.name == "Logout") {
            final response = await request.logout(
                "http://localhost:8000/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Goodbye, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        ...
```

#### 2. Making a Custom Model in Flutter
For this step, I used the Quicktype website. I opened the JSON endpoint in my django website, and copypasted the data into Quicktype like below, then moved the result to a new file in lib/models/product_entry.dart.
![image](https://github.com/user-attachments/assets/844ed8c8-0d9f-46b3-b968-3301b6db15cd)
Then, to add HTTP dependency to my application, I ran the command flutter pub add http in my terminal, and put in the line below to android/app/src/main/AndroidManifest.xml:
```
<uses-permission android:name="android.permission.INTERNET" />
```
I also made a new file called list_productentry.dart in my screens folder, which follows the code given in the tutorial, but I additionally made sure the field names follow the model we just implemented, especially in this part of its code:
```
...
children: [
            Text(
              "${snapshot.data![index].fields.name}",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("${snapshot.data![index].fields.description}"),
            const SizedBox(height: 10),
            Text("${snapshot.data![index].fields.price}"),
          ],
...
```
I added this page to the left drawer by including the following ListTile in left_drawer.dart:
```
ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Product List'),
            onTap: () {
              // Route to the mood page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductEntryPage()),
              );
            },
          ),
```
Similarly, I also modified the View Products button in product_card.html to go to ProductEntryPage().

#### 3. Integrating the Flutter forms with Django Services
First, I created a new function in main/views.py of my Django project.
```
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse

@csrf_exempt
def create_product_flutter(request):
    if request.method == 'POST':

        data = json.loads(request.body)
        new_product = Product.objects.create(
            user=request.user,
            name=data["name"],
            price=int(data["price"]),
            description=data["description"]
        )

        new_product.save()

        return JsonResponse({"status": "success"}, status=200)
    else:
        return JsonResponse({"status": "error"}, status=401)
```
I also route it in main/urls.py: 
```
path('create-flutter/', create_product_flutter, name='create_product_flutter'),
```
Then I added this line to lib/widgets/productentry_form.dart, right after the Widget build line: 
```
final request = context.watch<CookieRequest>();
```
I also changed the onPressed() button's code to the following: 
```
onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Send request to Django and wait for the response
                      final response = await request.postJson(
                        "http://localhost:8000/create-flutter/",
                        jsonEncode(<String, String>{
                          'name': _name,
                          'price': _price.toString(),
                          'description': _description,
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("New mood has saved successfully!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Something went wrong, please try again."),
                          ));
                        }
                      }
                    }
                  },
```
With that, the code for this week's assignment is complete.
</details>  

<details>  
<summary>WEEK 7 - Assignment 8 </summary>

 ### What is the purpose of const in Flutter? Explain the advantages of using const in Flutter code. When should we use const, and when should it not be used?

The const keyword in Flutter is used to define immutable widgets or objects at compile-time, meaning their values cannot change at runtime. A benefit of the const keyword is that it saves memory because Flutter uses the same memory space for all instances of a const object. Also, in the case of a rebuild, Flutter knows that the const is an object that shouldn't be changed, so it doesn't rebuild the const and this improves performance.

 ### Explain and compare the usage of Column and Row in Flutter. Provide example implementations of each layout widget!

 Column and Row are layout widgets that organize child widgets in vertical and horizontal directions, respectively. Column arranges children from top to bottom, making it ideal for stacking content vertically, while Row arranges widgets left to right, suited for side-by-side elements. Both widgets provide alignment options like mainAxisAlignment (primary axis) and crossAxisAlignment (secondary axis) for fine-tuning layouts, but they differ in their axis orientation. Column is for vertical layouts while Row is for horizontal layouts.

 ### List the input elements you used on the form page in this assignment. Are there other Flutter input elements you didn’t use in this assignment? Explain!
In this form, this is the input element I used:

  TextFormField: This was used for entering the product name, description, and amount, with validations for required fields and ensuring the amount is a valid number.

Some other common Flutter input elements I didn’t use in this assignment:

  1. Checkbox: Typically used for boolean options, where users select or deselect an item.
  2. Radio: Allows selection of one option from a group of mutually exclusive options.
  3. Switch: Similar to a Checkbox, but represented as a toggle button.
  4. DropdownButtonFormField: Useful for selecting one option from a predefined list.
  5. Slider: Lets users pick a value from a range, ideal for adjusting values like brightness or volume.

 ### How do you set the theme within a Flutter application to ensure consistency? Did you implement a theme in your application?
 In Flutter, themes can be set through ThemeData within the MaterialApp widget. This allows us to define global styles for text, buttons, and other components to make a cohesive look across the app. In my app, I implemented it like this within the MyApp class in main.dart:

```
       theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.black,
        secondary: Colors.grey[900],
      ),
        useMaterial3: true,
      ),
```

Here, I define the primary color to be black and the secondary color to be grey[900], and I also configure it so that we can use UI components from Material3.

 ### How do you manage navigation in a multi-page Flutter application?
 Navigation in Flutter is primarily managed using the Navigator class, which maintains a stack of pages (routes). Navigator.push() adds a new page to the stack, while Navigator.pop() removes the current page, allowing users to go back to their previous page. Alternatively, named routes can be defined for navigation using route names, enabling easier management of multiple pages. We can use the Navigator in Inkwells and GestureDetectors which can be found in components like BottomNavigationBar or Drawer.
 For example, this is how Navigator is implemented in my app to redirect the user to the Product Entry Form Page. 
 ```
  Navigator.pushReplacement(context, 
  // ignore: prefer_const_constructors
  MaterialPageRoute(builder: (context) => ProductEntryFormPage(),
  ));
 ```

</details>

<details>  
<summary>WEEK 6 - Assignment 7</summary>

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

#### 1. Make the Flutter App
First, we can create a new Flutter app by running the following commands in the terminal. This initializes a new directory with the name of the app (cosmique in this case), complete with the basic files needed to launch and run a demo of the app.

```
flutter create cosmmique
cd cosmique
```

### 2. Configure main.dart
We can import the following package into our main.html so that we can use Flutter widgets implementing Material Design in our application.
```
import 'package:flutter/material.dart';
```
After that, make a new file called menu.dart in the lib folder for implementing extra widgets separately into our app so that we don't overcrowd too many things in just one file. Then, import that dart file into main.dart. Along with that, we can hide the debug banner by setting debugShowCheckedModeBanner to false, then, we can configure the color palette of our app in the theme section. In here, I'm configuring the primary swatch to grey, then setting the secondary color to grey[900]. Make sure the useMaterial3 feature is checked true, to use the latest version of Google's Material Design.

All in all, alter the main.dart to look like below. We change the code to call a MyHomePage() class that we can define in menu.dart.
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

### 3. Make the Item Home Page Widget

In menu.dart, make a new ItemHomepage class to contain information to pass through to the other widgets we might want to make. This class will take on 3 constants, a string object, an iconData object, and a color object. The constructor ItemHomepage(this.name, this.icon, this.iconColor); is a special method used to create instances of the ItemHomepage class. The this keyword refers to the current instance of the class, allowing the constructor parameters (name, icon, and iconColor) to be assigned directly to the class's instance variables without needing to use explicit assignments like this.name = name;.
```
class ItemHomepage {
     final String name;
     final IconData icon;
     final Color iconColor;

     ItemHomepage(this.name, this.icon, this.iconColor);
 }
```

### 4. Make the Item Card Widget
Then, in menu.dart, we can make an ItemCard class which returns a Material widget that is clickable because it is wrapped in an Inkwell. When the inkwell, is tapped, a snack bar will appear to display a text that says which button has been pressed. The ItemCard's color depends on the iconColor constant of an item defined in ItemHomePage.
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



### 5. Make the Info Card Widget
In menu.dart, we also make an InfoCard class which returns a Card widget and displays a title and a content text in a container. MediaQuery.of(context).size.width / 3.5, allows the width of the infocard to adjust to the size of the screen whihle also keeping enough spsace for 3 infoCards, because we plan to display them horizontally in a GridView later. 
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

### 6. Displaying the Widgets
Lastly, in menu.dart, we can display all the widgets we have made in a class MyHomePage, which returns a Scaffold. We pass the information that we want to display in our widgets and adjust how they are arranged in here. In the end, the application will display the npm, name and className strings in 3 separate InfoCards along with 3 buttons displayed in a gridview below it, which will be filled with content that has been declared in List<ItemHomepage> items. I declare each member of the list to have a different value for iconColor so that every itemCard will have a different color.
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
