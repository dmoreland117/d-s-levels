
# D's Level Manager (Alpha 1.0)
![Level Manager UI](screenshots/level_manager_screen.png)

A Level Manager built for the Godot Engine using GDScript. If you would like to contribute let me know at dmoreland117@gmail.com

## Freatures
* Level Management UI for adding, removing and editing Level info.
* Loading Screen management UI
* In game loading of levels via the Levels Singleton
* Can Automatically show Loading Screens while chaanging Levels.

## Ussage
1. Clone this repo
```bash
git clone https://github.com/dmoreland117/d-s-levels.git
```
2. Copy the addons/ds_levels into your projects addons folder
3. Open your godot project and enable the d's levels plugin
4. somewhere in your project create resource files with the types LevelDataStorage and LoadingScreneDataStorage
5. re-open the Project Settings and navigate to ds levels > directories and set the loading screen and level storage paths to the files created in step 4
6. Now you can add Levels and Loading Screens in the levels tab at the top of the scren.
7. in your game world add a LevelContainer2D, 3D
8. in script call
```gdscript
Levels.change_to_level(Levels.get_level_storage().get_data_by_label('lvl2'), 'spawn_point'. {'arg 1': 'hello'})
```

## TODO
* Clean up code a bit
* Write docs
* Post a demo Video