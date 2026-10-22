import UIKit

class ListViewController: UIViewController {

    private let titleLabel = UILabel()
    private let tableView = UITableView()
    var workouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTitleLabel()
        setupTableView()
        loadInitialMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Workout Log"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadInitialMockData() {
        workouts = [
            Workout(name: "Morning Run", type: .cardio, duration: 30.0, date: Date()),
            Workout(name: "Squats", type: .strength, duration: 45.0, date: Date())
        ]
        tableView.reloadData()
    }
    
    @objc private func didTapAddButton() {
        print("Add button tapped!")
        
        let formVC = WorkoutFormViewController(workout: nil)
        
        formVC.delegate = self
        
        let navigationWrapper = UINavigationController(rootViewController: formVC)
        present(navigationWrapper, animated: true, completion: nil)
    }
}

// MARK: - WorkoutFormViewControllerDelegate Extension
extension ListViewController: WorkoutFormViewControllerDelegate {
    func workoutFormDidUpdate(_ workout: Workout) {
        // Using '===' to check if it's the exact same memory instance pointer
        if let index = workouts.firstIndex(where: { $0 === workout }) {
            // Because it's a class reference, the data inside workouts[index]
            // is ALREADY updated! Just need to tell the UI to refresh.
            workouts[index] = workout
        } else {
            // Brand new workout instance pointer, append it.
            workouts.append(workout)
        }
        tableView.reloadData()
    }
}

// MARK: - UITableView Data Source & Delegate Extensions
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    /*
     
    - Set up the `UITableViewDataSource`:
        - `tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int` will be the number of rows in your array
        - `tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell` will be you setting up a cell:
    
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WorkoutTableViewCell.identifier,
            for: indexPath
        ) as? WorkoutTableViewCell else {
            return UITableViewCell()
        }
        
        let selectedWorkout = workouts[indexPath.row]
        cell.configure(with: selectedWorkout)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedWorkout = workouts[indexPath.row]
        let detailVC = WorkoutDetailViewController(workout: selectedWorkout)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Preview
#Preview {
    let navController = UINavigationController(rootViewController: ListViewController())
    return navController
}

