//
//  ViewController.swift
//  lab2
//
//  Created by Dias Yerlan on 23.02.2025.
//

import UIKit

protocol ProfileUpdateDelegate {
    // TODO: Consider protocol inheritance requirements
    // Think: When should we restrict protocol to reference types only?
    func profileDidUpdate(_ profile: UserProfile)
    func profileLoadingError(_ error: Error)
}



class ProfileManager {
    // TODO: Think about appropriate storage type for active profiles
    private var activeProfiles: [String: UserProfile] = [:]
    
    // TODO: Consider reference type for delegate
    var delegate: ProfileUpdateDelegate?
    
    // TODO: Think about reference management in closure
    var onProfileUpdate: ((UserProfile) -> Void)?
    
    init(delegate: ProfileUpdateDelegate) {
        // TODO: Implement initialization
    }
    
    func loadProfile(id: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // TODO: Implement profile loading
        // Consider: How to avoid retain cycle in completion handler?
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in // Capture self weakly to prevent retain cycle
            guard let self = self else { return }
            
            // Mock profile data
            let profile = UserProfile(id: id, username: "diasyerlan", bio: "iOS Developer", profileImageURL: nil)
            self.activeProfiles[id] = profile
            DispatchQueue.main.async {
                completion(.success(profile))
                self.delegate?.profileDidUpdate(profile)
                self.onProfileUpdate?(profile)
            }
        }
    }
}



class UserProfileViewController: UIViewController, ProfileUpdateDelegate, ImageLoaderDelegate  {
    
    
    
    // TODO: Consider reference type for these properties
    var profileManager: ProfileManager?
    var imageLoader: ImageLoader?
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let bioLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProfileManager()
        loadUserProfile()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bioLabel.font = UIFont.systemFont(ofSize: 16)
        bioLabel.numberOfLines = 0
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel, bioLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    func setupProfileManager() {
        // TODO: Implement setup
        profileManager = ProfileManager(delegate: self)
        
        // Use weak self in closure to prevent retain cycle
        profileManager?.onProfileUpdate = { [weak self] profile in
            self?.updateProfile(with: profile)
        }
    }
    
    func loadUserProfile() {
        profileManager?.loadProfile(id: "user_123") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.updateProfile(with: profile)
            case .failure(let error):
                self?.profileLoadingError(error)
            }
        }
    }
    
    func updateProfile(with profile: UserProfile) {
        // TODO: Implement profile update
        // Consider: How to handle closure capture list?
        
        nameLabel.text = profile.username
        bioLabel.text = profile.bio
        
        if let url = profile.profileImageURL {
            imageLoader = ImageLoader()
            imageLoader?.delegate = self
            
            imageLoader?.completionHandler = { [weak self] image in
                self?.profileImageView.image = image ?? UIImage(systemName: "person.crop.circle")
            }
            
            imageLoader?.loadImage(from: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    
}


extension UIViewController {
    func profileDidUpdate(_ profile: UserProfile) {
        print("Profile updated: \(profile.username)")
        
    }
    
    func profileLoadingError(_ error: any Error) {
        print("Failed to load profile: \(error.localizedDescription)")
        
    }
    
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage) {
        print("Image loaded via delegate")
        
    }
    
    func imageLoader(_ loader: ImageLoader, didFailWith error: any Error) {
        print("Image loading failed: \(error.localizedDescription)")
        
    }
    
    
}
