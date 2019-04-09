# RxSwift-Realm-XCodeTemplate
A template for creating project in xcode with RxSwift + Realm.
Inspired by the book "Reactive Programming with Swift" by the raywenderlich.com Tutorial team

# References
- switch to branch "features/Example" to see Example of how to use this template
- read the last chapter of the book "Reactive Programming with Swift" by Raywenderlich

# Installation
1. Copy folder File Templates and Project Templates to "~/Library/Developer/Xcode/Templates/"
2. Restart xcode
3. Create new project by choosing "RxSwift + Realm" in Project Templates group
4. Close project
5. Navigate to project's folder in Terminal
6. Install pod by "pod install"
7. Open project by command "xed ."
8. Remove Podfile reference in project if wanted

# Using the templates
## 1. Create RealmEntity using RealmEntity Template
### 1.1 Navigate to File > New > File...
### 1.2 Name the entity and the file name, for example "Task" for TODO app (see "Examples")
You got a Realm Entity, a EntityService for CRUD, a Entity(s)ViewModel and a Entity(s)TableViewController
### 1.3 Edit Entity and its properties, it's mock objects (see Examples)
### 1.4 Edit EntityService and add helpers method if needed
## 2. Design TableViewController and Cells in storyboard
## 3. Add ListViewModel & ListViewController using ListVVM Template
## 4. Link TableViewController and Cells
## 5. Edit sectionedItems in Entity(s)ViewModel
## 6. configure dataSources in Entity(s)TableViewController
## 7. Add Scene
### 7.1 edit Scene.swift
### 7.2 inititalize Scene + ViewController
## 8. Kick-off first Scene in AppDelegate.swift
## 9. (Optional) add EditEntity by using BindableVVM template
### 9.1 Navigate to File > New > File... and choose the template BindableVVM
You got 2 file Edit<Entity>ViewController and Edit<Entity>ViewModel for Edit<Entity>Scene
### 9.2 Design Edit<Entity>VC in Storyboard
### 9.3 Edit Edit<Entity>ViewModel
