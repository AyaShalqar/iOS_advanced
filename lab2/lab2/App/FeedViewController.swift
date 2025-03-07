//
//  Feed.swift
//  lab2
//
//  Created by Dias Yerlan on 24.02.2025.
//

import Foundation
import UIKit

class FeedSystem {
    private var userCache: [String: UserProfile] = [:] // O(1) access with Dictionary
    private var feedPosts: [Post] = [] // Ordered list of posts
    private var hashtags: Set<String> = [] // Unique, fast lookup

    func addPost(_ post: Post) {
        feedPosts.insert(post, at: 0) // Insert at beginning for newest first
        userCache[post.author.id] = post.author
        hashtags.formUnion(post.hashtags)
    }

    func removePost(_ post: Post) {
        if let index = feedPosts.firstIndex(of: post) {
            feedPosts.remove(at: index)
        }
    }

    func getPosts() -> [Post] {
        return feedPosts
    }
}

// MARK: - FeedViewController
import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let feedSystem = FeedSystem()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSamplePosts()
    }

    private func setupUI() {
        title = "Feed"
        view.backgroundColor = .systemBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadSamplePosts() {
        let user1 = UserProfile(id: "1", username: "alice", bio: "", profileImageURL: nil)
        let user2 = UserProfile(id: "2", username: "bob", bio: "", profileImageURL: nil)

        let post1 = Post(id: UUID(), author: user1, hashtags: ["welcome"], content: "Hello World! #welcome")
        let post2 = Post(id: UUID(), author: user2, hashtags: ["sunny", "weekend"], content: "Loving the sunny weather! #sunny #weekend")

        feedSystem.addPost(post1)
        feedSystem.addPost(post2)

        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedSystem.getPosts().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = feedSystem.getPosts()[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "@\(post.author.username): \(post.content)"
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
