# Insane-Engine

> a tool to make new love2d projects easily.

## Installation

### Configure and build new projects
```bash
# cd to where you installed the Engine

# Compile the Configuration file (You can replace "Config" with any other name)
$ gcc -o Config Config.c Insane.c

# Configure
$ ./Config

# Compile the main code (You can replace "Initialiser" with any other name)
$ gcc -o Initialiser Initialiser.c Insane.c

# Add the path to global variables and
$ Initialiser [GameName]
```

### Add the path to global variables
It depends on the OS you are using.

## Edit Project

### Meta info
Open Engine/Meta.lua. This file contains most of the settings for your project (for eg. Window name, Window resolution, Virtual resolution etc.). 

#### Window Setup 
The file contains `VIRTUAL_WIDTH` and `VIRTUAL_HEIGHT` which is the size of the canvas of your game which will be scaled up to `WINDOW_WIDTH` and `WINDOW_HEIGHT` using push library (developed by Ulysse Ramage).

You can edit the PushSetup table to edit properties like fullscreen, resizable.

#### Scenes
The game can be divided into different scenes like MainMenu, Level1 etc. All these scenes are managed by the SceneManagement based on the type you choose. SceneManagement loads the Main Scene by calling ``Scenes["Main"]``

You can set the Main scene by assigning a function to "Main" key in Scenes table.
The function should return the newly created scene.
For eg. 
```
Scenes = {
    ["Main"] = function () return MainMenu() end
}

```

## Scene
The game can be divided into different scenes like MainMenu, Level1 etc. 

### Creating new Scene Class
Create a new file with the name you like (We will take "MainMenu" for this documentation) with a ".lua" extension. Make sure to include the file in the Dependencies.lua by calling `require(PATH_TO_SCENE_FILE)`.

In the file declare the new class which inherits from the base Scene class
-> ``MainMenu = Class{__includes = Scene}``

The base class has 5 functions: 
* init
* update
* render
* enter
* exit

You can override any of these functions to get the desired behaviour.

### init function 
This function is called when the scene is instantiated by the SceneMangement. If you override this function make sure to add an empty table named GameObjects. eg. 
```

function MainMenu:init()
    self.GameObjects = {}
    -- logic
end

```

You can pass additional parameters as well but more on that later.

### Update function
This function is called every frame update. The function is passed with the delta time by the SceneManagement.

### Render function
You can render different things by overwriting this function.

### Enter and Exit function
The exit function is called before the scene is discarded. 

The enter function is called after the scene is instantiated.

## GameObjects
A scene has a GameObjects table which includes the objects which have different behaviour. It is recommended to use GameObjects for scenes with few objects.

### Creating a new GameObject
To create a new GameObject call GameObject(parameters) and add the newly created object to the GameObjects table by table.insert(Scene.GameObjects, GameObject).

If you want to access the GameObject with a specific name you can add it to the GameObjects table by ```Scene.GameObjects["Name"] = GameObject```

### Init function
The init function takes in a table of a few parameters which includes:
* x (The x position of the object) [0 by default]
* y (The y position of the object) [0 by default]
* sx (scale factor on x axis for rendering) [1 by default]
* sy (scale factor on y axis for rendering) [1 by default]
* width
* height
* sprite
* quad (if sprite is an image) [optional]
* mode (can be "fill" or "line") ["fill" by default]
* color (table of r g b a values) [{r = 1, g = 1, b = 1, a = 1} by default]
* solid 
* onCollide or onTrigger [collide if solid else trigger] [optional]
* render (bool whether to render this object) [true by default]
* components (Scripts on the object) 

### Sprite
The object is rendered based on the sprite you specify. 
[Note: the object is rendered at x,y position where x and y specifies the top left point.]

#### Rectangles
if the sprite is "rectangle", you need to specify the width and height of the object in init table.

The object will draw a simple rectangle on the screen at x, y position, which has width and height as specified by you. in order to make it look pretty you can optionally specify the border radius in init parameters by adjusting corners property.

#### Textures / Images
if the sprite is an image created by ```love.graphics.newImage("PATH_TO_IMAGE")```, either you can render the whole image or a part of it.

To render the complete image don't specify any quad in init table, the complete image will be drawn on the screen at x, y position. 

The width and height of the object is the width and height that you pass in the init parameters. If you dont specify any it will be the with and height of the Image itself.

To render a part of it, specify a quad created by ```love.graphics.newQuad(PARAMETERS)```. The width and height of the object is the width and height of the quad that you pass. 

#### Circle / Ellipse
The sprite can be a "Circle" or an "Ellipse".

To render a circle you need to specify the width of the object and the corners (segments of circle) in the init parameters.

To render an ellipse you need to specify the width, height and the corners of the object.

### Collision
The object has AABB collision logic and acts for all types of sprites as if they are simple rectangles.

#### onCollide
This function is called when both the objects are solid. This function is passed in the object itself if needed.

#### onTrigger
This function is called if the object itself is not solid but the other object is solid.

Every time onCollide or onTrigger function is called, object also calls the onCollide function of each component of the object and passes the parent object and the object it collided with.

## UI
You can create UI elements for your scene by calling ```UI(PARAMETERS)``` and add them to the scene by ```table.insert(Scene.GameObjects, UI_ELEMENT)```. If you want to access the UI element with a specific key you can add it by ```Scene.GameObjects["KEY"] = UI_ELEMENT```.

### init function
The init function, just like the GameObjects take a table of parameters:
* x (The x position of the object) [0 by default]
* y (The y position of the object) [0 by default]
* width
* height
* color
* corners
* type
* onClick
* onHover
* handleMode
* handleColor
* handleWidth
* handleCorners
* value
* maxValue
* mode
* render (bool whether to render this object) [true by default]
* components (Scripts on the element)
* interactable
* textColor
* text
* backgroundColor

### types
It currently supports buttons and sliders only.

### Buttons
Buttons are simple rectangles which are drawn on the screen at the position x and y, you need to specify the width and height of the UI element in the init parameter. In order to make it look good you can set border-radius of the button by specifying the corners key.

You can check if the button was pressed by ```Button.wasPressed``` which is a boolean.

You can temporarily disable button by setting interactable flag to false. If you want to display any text inside of the button you can set it by providing text in init parameters.

### Sliders
Sliders are UI elements which draw two rectangles (one for handle, one for background). Both the handle and slider have different properties which you need to specify. 

The handle will be drawn at handleX and handleY. The handle's width and height can be set by handleWidth and handleHeight respectively. The handle's color can be set using handleColor.

You need to specify the maxValue for the slider, and the current value can be accessed through ```Slider.value```. If you want to know whether the slider is being dragged, you can access ```Slider.beingDragged```.

You can set the color of the area which is value of the slider by setting backgroundColor property in init Parameters. 


### onHover
This function is called when the user hovers over the button or the slider.

### onClick
This function is called when the user clicks on the button


## Components 
The components are just simple scripts which can help you factor out logic for each gameobject. You can specify the component in Gameobject.components table.

### Animator
Animator is a type of component which can be added to the gameobject. An animator can be added to any object which uses quads for rendering. If you add Animator to a GameObject the toBeRendered attribute of the Object will be set to false.

To render using Animator add the Animator component to the GameObject by ```table.insert(GameObject.components, ANIMATOR)``` or ```GameObject.components["Anim"] = ANIMATOR```.

init function of Animator takes a table which contains:
* animations (table of all the Animations)
* default (key of default Animation)

### Animation
init function of Animation takes a table which contains:
* frames
* interval
* loop (bool whether to loop or not)
* scaleX (1 by defualt)
* scaleY (1 by defualt)

#### frames
frames is a table of quads which are 1 indexed.

### update function
Every component can have a update function. Update function is passed deltatime and the parent object.

### onCollide function
Every component can have a onCollide function, which is called every time the parent object collides with any other object. The onCollide function is passed the Parent object and the object with which the parent object collided.

## Scene Management
There are two supported types of scene management ("normal" and "stack"). 

### normal
The normal SceneManager processes only one scene at a time. 
You can access the current scene by ```SceneManagement.activeScene```.

#### Switch to new Scene
To switch to a new scene call ```SceneManagement:loadScene(SCENE_KEY, exitParameters, initParameters, enterParameters)```

This will call the exit function of the current scene and pass the `exitParameters` to the scene. After that it will replace that scene with the scene by calling ```Scenes[KEY]``` and pass the initParameters. After the scene is created the enter function of new scene is called and enterParameters is passed.

If no scene key is passed the SceneManagement will load the Main scene.

Everytime a new scene is loaded, enter function is called of every component of every object in the scene and the parent object is passed as parameter.

### stack
The stack SceneManagement manages all the scenes by storing them in a stack. All the Scenes in the stack are rendered. Only the top scene in the stack is updated.

#### Push
To push a new Scene call ```SceneManagement:push(SCENE_KEY, initParameters, enterParameters)```. This will create a new Scene by calling ```Scenes[SCENE_KEY]``` and pass initParameters. After that it will call enter function of top scene and pass enterParameters.

Only the scene at the top of stack is updated, but all the scenes in the stack are rendered from bottom to top.

Everytime a new scene is loaded, enter function is called of every component of every object in the scene and the parent object is passed as parameter.

#### Pop
This function calls the exit function of scene at the top of stack and pass the exitParameters. After that it removes the scene from the stack.

### update data flow
1. The update function of the required scene is called and the deltatime is passed as a parameter.
2. For every Object in GameObjects of the scene:
    * Object's update function is called and deltatime is passed.
    * All the components of the object is updated, deltatime and the parent object is passed as the parameters.
    * It is checked whether this object is colliding with any other object in the scene.

### render data flow
1. The render function of scene is called.
2. The render function of every GameObject in the scene is called.


## Util
The Util.lua is a simple file which contains two functions:

### newSpriteSheet
This function helps you create a table of quads (1 indexed). 
To create a new table call ```Util.newSpriteSheet(TEXTURE, WIDTH, HEIGHT)```

This will create a table of equal sized quads and return it. The Texture is divided row by row from left to right.

### tableSlice
```Util.tableSlice(TABLE, START_INDEX, END_INDEX)```
This function will just return a part of the table specifies from START_INDEX to END_INDEX.

If START_INDEX is not provided it will return from 0 to END_INDEX.
If END_INDEX is not provided it will return from START_INDEX to end of TABLE.

## Knife
Knife library has a few cool features like Timer. Read about it here: https://github.com/airstruck/knife