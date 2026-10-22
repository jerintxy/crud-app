import UIKit

protocol WorkoutFormViewControllerDelegate: AnyObject {
    func workoutFormDidUpdate(_ workout: Workout)
}

// Subclasses UITableViewController directly to manage the form inputs cleanly
class WorkoutFormViewController: UITableViewController {
    
    weak var delegate: WorkoutFormViewControllerDelegate?
    
    // A property to take in an optional Item reference (nil for Add, instance for Edit)
    var workoutToEdit: Workout?
   
    // Form Input UI Elements (Declared programmatically)
    private let nameTextField = UITextField()
    private let typeSegmentedControl = UISegmentedControl(items: WorkoutType.allCases.map { $0.rawValue })
    private let durationTextField = UITextField()
    private let datePicker = UIDatePicker()
    
    // Custom initialiser to inject the optional reference object
    init(workout: Workout? = nil) {
        self.workoutToEdit = workout
        super.init(style: .insetGrouped) // Matches detail screen styling cleanly
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dynamic title configuration based on item state
        title = (workoutToEdit == nil) ? "Add Workout" : "Edit Details"
        view.backgroundColor = .systemGroupedBackground
        
        setupNavigationButtons()
        setupInputFields()
        prefillExistingDataIfNeeded()
    }
    
    private func setupNavigationButtons() {
        // Standard Cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        // Standard Save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(didTapSave)
        )
    }
    
    private func setupInputFields() {
        // 1. String: Name text field configuration
        nameTextField.placeholder = "e.g., Upper Body"
        nameTextField.clearButtonMode = .whileEditing
        
        // 2. Enum: Segmented control defaults
        typeSegmentedControl.selectedSegmentIndex = 0
        
        // 3. Number: Duration configuration
        durationTextField.placeholder = "Minutes"
        durationTextField.keyboardType = .numberPad // Forces numerical pad keyboard
        
        // 4. Date: Date picker layout configuration
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
    }
    
    private func prefillExistingDataIfNeeded() {
        // If an item reference exists, map it into our form text components immediately
        guard let workout = workoutToEdit else { return }
        
        nameTextField.text = workout.name
        durationTextField.text = String(Int(workout.duration))
        datePicker.date = workout.date
        
        if let index = WorkoutType.allCases.firstIndex(of: workout.type) {
            typeSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSave() {
        print("Saving....")
        
        // Read values from inputs safely
        let finalName = nameTextField.text?.isEmpty == false ? nameTextField.text! : "Unnamed Workout"
        let selectedType = WorkoutType.allCases[typeSegmentedControl.selectedSegmentIndex]
        let finalDuration = Double(durationTextField.text ?? "0") ?? 0.0
        let finalDate = datePicker.date
        
        // Determine if we are editing or creating fresh
        if let workout = workoutToEdit {
            // Editing path: Update the properties of the class instance reference
            workout.name = finalName
            workout.type = selectedType
            workout.duration = finalDuration
            workout.date = finalDate
            
            // Pass the updated instance back
            delegate?.workoutFormDidUpdate(workout)
            
        } else {
            // Generate a new Workout class instance
            let newWorkout = Workout(name: finalName, type: selectedType, duration: finalDuration, date: finalDate)
            
            // Pass this brand-new instance back to the delegate array!
            delegate?.workoutFormDidUpdate(newWorkout)
        }
        
        // Dismiss the form view presentation layer
        dismiss(animated: true, completion: nil)
    }


    // MARK: - Table View Static Form Structure
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // 1 section for each of our 4 fields to display beautifully inside inset boxes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Workout Name"
        case 1: return "Activity Type"
        case 2: return "Duration (Mins)"
        case 3: return "Date"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FormCell")
        cell.selectionStyle = .none
        
        // Inject layouts cleanly across rows via inline sizing frames
        switch indexPath.section {
        case 0:
            nameTextField.frame = cell.contentView.bounds.insetBy(dx: 16, dy: 0)
            nameTextField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(nameTextField)
        case 1:
            typeSegmentedControl.frame = cell.contentView.bounds.insetBy(dx: 16, dy: 6)
            typeSegmentedControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(typeSegmentedControl)
        case 2:
            durationTextField.frame = cell.contentView.bounds.insetBy(dx: 16, dy: 0)
            durationTextField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(durationTextField)
        case 3:
            datePicker.frame = cell.contentView.bounds.insetBy(dx: 16, dy: 6)
            datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(datePicker)
        default:
            break
        }
        
        return cell
    }
}

