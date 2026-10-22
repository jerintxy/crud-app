import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    static let identifier = "WorkoutCellIdentifier"
    
    // 1. Declare a manual UIImageView so we have absolute control over its frame sizing
    private let typeIconView = UIImageView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    
    // Set up the initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        // 2. Configure the icon image view rendering rules
        typeIconView.contentMode = .scaleAspectFit
        typeIconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(typeIconView)
        
        // Style your text labels
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        detailsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = .secondaryLabel
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, detailsLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStackView)
        
        // 3. Set rigid size dimensions for the icon so it stays uniform and looks perfect
        NSLayoutConstraint.activate([
            // Pin icon safely on the left edge centered vertically
            typeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeIconView.widthAnchor.constraint(equalToConstant: 24),  // Forces exact width
            typeIconView.heightAnchor.constraint(equalToConstant: 24), // Forces exact height
            
            // Push text stack view to the right of your newly pinned icon
            textStackView.leadingAnchor.constraint(equalTo: typeIconView.trailingAnchor, constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    /*
    - Write a `configure(with item: Item)` method that populates all labels.
        - Use `DateFormatter` for dates.
        - If labels in horizontal stacks stretch weirdly, look into content hugging priorities and stack alignment.
    */
    
    func configure(with workout: Workout) {
        titleLabel.text = "\(workout.name) (\(workout.type.rawValue))"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: workout.date)
        detailsLabel.text = "\(Int(workout.duration)) mins • \(dateString)"
        
        // 4. Load the SF symbol using point size rules so line weights scale accurately
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let imageName = (workout.type == .strength) ? "dumbbell.fill" : "figure.run"
        
        typeIconView.image = UIImage(systemName: imageName, withConfiguration: config)
        typeIconView.tintColor = (workout.type == .strength) ? .systemOrange : .systemBlue
    }
}


