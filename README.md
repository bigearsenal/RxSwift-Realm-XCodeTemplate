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
Task.swift (Task is an Entity)
``` 
final class Task: Object, Mockable {
    // MARK: - Object
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil

    override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Mockobject
    static func createMockingObjects() {
        let service = TaskService()
        
        ["Chapter 5: Filtering operators",
         "Chapter 4: Observables and Subjects in practice",
         "Chapter 3: Subjects",
         "Chapter 2: Observables",
         "Chapter 1: Hello, RxSwift"].enumerated().forEach {
            service.create(["title": $1, "id": $0])
        }
    }
}

extension Task: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
```
### 1.4 Edit EntityService and add helpers method if needed
Example: add toggle method to TaskService.swift
```
@discardableResult
    func toggle(item: Task) -> Observable<Task> {
        let result = withRealm("toggling") { realm -> Observable<Task> in
            try realm.write {
                if item.checked == nil {
                    item.checked = Date()
                } else {
                    item.checked = nil
                }
            }
            return .just(item)
        }
        return result ?? .error(TaskServiceError.toggleFailed(item))
    }
```
## 2. Design TablesViewController and Cells in storyboard
## 3. Edit sectionedItems in Entity(s)ViewModel
TasksViewModel.swift
```
override var sectionedItems: Observable<[TaskSection]>! {
        return self.service.list(predicate: predicate)
            .map { results in
                let dueTasks = results
                    .filter("checked == nil")
                    .sorted(byKeyPath: "added", ascending: false)

                let doneTasks = results
                    .filter("checked != nil")
                    .sorted(byKeyPath: "checked", ascending: false)

                return [
                    TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                    TaskSection(model: "Done Tasks", items: doneTasks.toArray())
                ]
        }
    }
```
## 4. configure dataSources in Entity(s)TableViewController
TasksTableViewController.swift
```
fileprivate func configureDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Task>>(
            configureCell: {
                [weak self] dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: indexPath) as! TaskItemTableViewCell
                
                if let strongSelf = self,
                    let viewModel = strongSelf.viewModel as? TasksViewModel{
                    cell.configure(with: item, action: viewModel.onToggle(item: item))
                }
                return cell
            },

            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }
        )
    }
```
## 5. Add Scene
### 5.1 edit Scene.swift
Scenes/Scene.swift
```
enum Scene {
    case tasks(TasksViewModel)
    // Add case editTask(EditTaskViewModel) later
}
```
### 5.2 inititalize VC by editing Scene+ViewController.swift
Scenes/Scene+ViewController.swift
```
func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .tasks(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            var vc = nc.viewControllers.first as! TasksTableViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .editTask(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            var vc = nc.viewControllers.first as! EditTaskViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
```
## 6. Kick-off first Scene
AppDelegate.swift
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let coordinator = SceneCoordinator(window: window!)
        
        let service = TaskService()
        let tasksViewModel = TasksViewModel(router: "", sceneCoordinator: coordinator, service: service)
        
        let firstScene = Scene.tasks(tasksViewModel)
        coordinator.transition(to: firstScene, type: .root)
        
        return true
    }
```
## 7. (Optional) add EditEntity by using BindableVVM template
### 7.1 Navigate to File > New > File... and choose the template BindableVVM
You got 2 file Edit<Entity>ViewController and Edit<Entity>ViewModel for Edit<Entity>Scene
### 7.2 Design Edit<Entity>VC in Storyboard
### 7.3 Edit Edit<Entity>ViewModel, bind ViewModel to ViewController
### 7.4 Add Scene Edit
Scenes/Scene.swift
```
enum Scene {
    case tasks(TasksViewModel)
    case editTask(EditTaskViewModel)
}
```
Scenes/Scene+ViewController.swift
```
extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .tasks(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            var vc = nc.viewControllers.first as! TasksTableViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .editTask(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            var vc = nc.viewControllers.first as! EditTaskViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
```
### 7.5 edit onCreate in Entity(s)ViewModeland navigate to EditEntityViewController
Entity(s)ViewModel
```
func onCreate() -> CocoaAction {
        return CocoaAction { _ in
            return self.service
                .create(["title": ""])
                .flatMap { item -> Observable<Void> in
                    let editViewModel = EditTaskViewModel(task: item,
                                                          coordinator: self.sceneCoordinator,
                                                          updateAction: self.onUpdate(item: item),
                                                          cancelAction: self.onDelete(item: item))
                    return self.sceneCoordinator
                        .transition(to: Scene.editTask(editViewModel), type: .modal)
                        .asObservable().map { _ in }
                }
        }
    }
```
