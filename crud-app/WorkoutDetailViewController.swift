//
//  WorkoutDetailViewController.swift
//  crud-app
//
//  Created by Jerin Tan on 19/10/26.
//

import UIKit

class WorkoutDetailViewController: UITableViewController {
    
    // reference property to store the passed Workout item
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        super.init(style: .insetGrouped) // Uses the sleek rounded card style layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the title bar text dynamically to match the workout's name
        title = workout.name
        view.backgroundColor = .systemGroupedBackground
        
        setupEditButton()
    }
    
    private func setupEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTapEditButton)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // refresh the detail table layout rows just in case values were updated in the Form view
        tableView.reloadData()
        title = workout.name
    }
    
    @objc private func didTapEditButton() {
        let formVC = WorkoutFormViewController(workout: self.workout)
        
        // Set the delegate to self instead of using a closure block
        formVC.delegate = self
        
        let navigationWrapper = UINavigationController(rootViewController: formVC)
        present(navigationWrapper, animated: true)
    }
    
    // MARK: - Table View Data Source Structure
    
    // Multiple sections! So numberOfSections will return more than 1.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // Section 0: Overview, Section 1: Workout Stats, Section 2: Log Details
    }
    
    // numberOfRowsInSection will need to check the current section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:  return 1 // Row 0: Name
        case 1:  return 2 // Row 0: Type, Row 1: Duration
        case 2:  return 1 // Row 0: Date
        default: return 0
        }
    }
    
    // section headers with the titleForHeaderInSection method
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:  return "Overview"
        case 1:  return "Workout Stats"
        case 2:  return "Log Details"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "DetailCell")
        
        cell.selectionStyle = .none
        
        // tuple switching to determine section and row formatting simultaneously
        switch (indexPath.section, indexPath.row) {
            
        // SECTION 0: OVERVIEW
        case (0, 0):
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = workout.name // 1. String
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            
        // SECTION 1: WORKOUT STATS
        case (1, 0):
            cell.textLabel?.text = "Activity Type"
            cell.detailTextLabel?.text = workout.type.rawValue // 2. Enum
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            
        case (1, 1):
            cell.textLabel?.text = "Duration"
            cell.detailTextLabel?.text = "\(Int(workout.duration)) mins" // 3. Number
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            
        // SECTION 2: LOG DETAILS
        case (2, 0):
            cell.textLabel?.text = "Logged Date"
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            cell.detailTextLabel?.text = formatter.string(from: workout.date) // 4. Date
            cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            
        default:
            break
        }
        
        return cell
    }
}

// MARK: - WorkoutFormViewControllerDelegate Conformance
extension WorkoutDetailViewController: WorkoutFormViewControllerDelegate {
    
    func workoutFormDidUpdate(_ workout: Workout) {
        // 1. Update the local workout reference with the edited data
        self.workout = workout
        
        // 2. Redraw the table rows with the new details
        self.tableView.reloadData()
        
        // 3. Update the navigation bar title string
        self.title = workout.name
    }
}
