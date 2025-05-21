//
//  FirebaseManager.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Combine
import FirebaseFunctions

class FirebaseManager {
    
    // MARK: - Singleton
    static let shared = FirebaseManager()
    
    // MARK: - Firebase Services
    let auth: Auth
    let db: Firestore
    let storage: Storage
    let functions: Functions
    
    // MARK: - State
    @Published var currentUser: User?
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    private init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
        self.functions = Functions.functions()
        
        configureFirestore()
        setupAuthListener()
    }
    
    // MARK: - Firestore Config
    private func configureFirestore() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
    }
    
    // MARK: - Auth Listener
    private func setupAuthListener() {
        authStateHandler = auth.addStateDidChangeListener { [weak self] _, firebaseUser in
            self?.currentUser = firebaseUser.flatMap { User(from: $0) }
        }
    }
    
    // MARK: - Helpers
    func currentUserId() -> String? {
        auth.currentUser?.uid
    }
    
    func currentUserToken() async throws -> String {
        guard let user = auth.currentUser else {
            throw NSError(domain: "FirebaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        return try await user.getIDToken()
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    deinit {
        if let handler = authStateHandler {
            auth.removeStateDidChangeListener(handler)
        }
    }
}

// MARK: - Firestore + Storage References
extension FirebaseManager {
    
    func userDocument(userId: String) -> DocumentReference {
        db.collection("users").document(userId)
    }
    
    func profileImageReference(userId: String) -> StorageReference {
        storage.reference().child("profile_images/\(userId).jpg")
    }
}
