//
//  ItemsViewController.swift
//  database
//
//  Created by Jacob Parker on 11/23/18.
//  Copyright © 2018 Santa Clara University. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm: Realm            // <- Insert this
    let items: Results<movie_data>
    let tableView = UITableView()
    
    let userRating = [4, 3, 3]
    let movieTitles = ("Black Panther", "Mission: Impossible - Fallout", "BlacKkKlansman")
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let syncConfig = SyncConfiguration(user: SyncUser.current!, realmURL: Constants.REALM_URL)
        self.realm = try! Realm(configuration: Realm.Configuration(syncConfiguration: syncConfig, objectTypes:[movie_data.self]))
        self.items = realm.objects(movie_data.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = self.view.frame
        newDatabase()
        let critics = matchCriticWithUser(with: movieTitles, and: userRating)
        print("Critic List")
        print("1. ", critics[0])
        print("2. ", critics[1])
        print("3. ", critics[2])
        let movieRecommendations = getMovieRecommendationsList(from: items, with: "Katie Walsh", with: "Horror")
        print("Movie Recommendation List")
        for index in 1...movieRecommendations.count {
            print("\(index). ", movieRecommendations[index-1].title!, " ", movieRecommendations[index-1].genre!)
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func newDatabase() {
        
        let semaphore = DispatchSemaphore(value: 1)
        let singleMovies = Array(Set(self.items.map({$0.title!})))
        var dataArray = Array<Movie>()
        for movie in singleMovies {
            OMDBsearchMovieByTitle(imdbTitle: movie) { (movie_info) -> () in
                semaphore.signal()
                dataArray.append(movie_info)
            }
            semaphore.wait()
        }
        
        for data in items {
            try! realm.write() {
                let new_data: movie_data = data
                let info = dataArray.first(where: {$0.Title == data.title})
                new_data.poster = info?.Poster
                new_data.genre = info?.Genre
                self.realm.add(new_data)
            }
        }

    }
    
    func matchCriticWithUser(with movieTitles: (String, String, String), and userRatings: [Int]) -> [String] {
        
        //find critic ratings given the imdbMovieIDs
        
        var criticToRatings = Dictionary<String, [Int]>()

        
        let movieInfo = items.filter {
            $0.title == movieTitles.0 ||
            $0.title == movieTitles.1 ||
            $0.title == movieTitles.2
        }
        
        //initialize values to avoid unwrapping nil optional
        for info in movieInfo {
            criticToRatings[info.criticName!] = []
        }
        
        //add ratings to dictionary
        for info in movieInfo {
            criticToRatings[info.criticName!]!.append(info.rating.value!)
        }
        
        criticToRatings = criticToRatings.filter { $0.value.count == 3 }
        
        //least squares differences between three ratings from user and critic
        
        return criticToRatings.sorted(by: { leastSquares(between: $0.value, and: userRatings) < leastSquares(between: $1.value, and: userRating) }).map({ $0.key })
    }
    
    func getMovieRecommendationsList(from movie_data_list: Results<movie_data>, with critic: String, with genre: String? = nil) -> [movie_data] {
        
        var movie_recommendations_list: [movie_data] = []
        
        if (genre == nil) {
            for movie in movie_data_list  {
                if movie.criticName! == critic {
                    movie_recommendations_list.append(movie)
                }
            }
        }
        else {
            for movie in movie_data_list  {
                if movie.genre != nil {
                    if movie.criticName! == critic && movie.genre!.range(of: genre!) != nil {
                        movie_recommendations_list.append(movie)
                    }
                }
            }
        }
        
        movie_recommendations_list = movie_recommendations_list.sorted(by: { $0.rating.value! > $1.rating.value! })
        
        return movie_recommendations_list
    }
    
    func leastSquares(between criticRating: [Int], and userRating: [Int]) -> Double {
        var diff: Double = 0
        diff += pow(Double(criticRating[0] - userRating[0]), 2)
        diff += pow(Double(criticRating[1] - userRating[1]), 2)
        diff += pow(Double(criticRating[2] - userRating[2]), 2)
        return diff
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

}
