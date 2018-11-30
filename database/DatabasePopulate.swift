import UIKit
import Foundation

struct Rating: Decodable{
    let Source: String?
    let Value: String?
}
class Movie: Decodable {
    
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Language: String?
    let Country: String?
    let Awards: String?
    let Poster: String?
    let Ratings: [Rating]?
    let Metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let `Type`: String?
    let DVD: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
    let Response: String?
    
}

func OMDBsearchMovieByID(ID imdbID: String, completion: @escaping (Movie) -> ()) { //completion: @escaping: asynchronous processing with URLSession
    let baseURL = "https://www.omdbapi.com/?apikey=21f0a994&i=" + imdbID + "&plot=full"
    let url = URL(string: baseURL)!
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else {return}
        //        let dataString = String(data: data, encoding: .utf8)
        //        print(dataString!)
        do{
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            completion(movie)
        } catch let jsonErr{
            print("Error parsing JSON:", jsonErr)
        }
        }.resume()
}

func OMDBsearchMovieByTitle(imdbTitle: String, releaseYear: Int? = nil, completion: @escaping (Movie) -> () ){
    var baseURL = ""
    let imdbTitleScrubbed = imdbTitle.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
    if(releaseYear == nil){
        baseURL = "https://www.omdbapi.com/?apikey=21f0a994&t=" + imdbTitleScrubbed + "&plot=full"
    }else{
        let syear = String(releaseYear!)
        baseURL = "https://www.omdbapi.com/?apikey=21f0a994&t=" + imdbTitleScrubbed + "&y=" + syear + "&plot=full"
    }
    let url = URL(string: baseURL)!
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        guard let data = data else {return}
        do{
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            completion(movie)
        } catch let jsonErr{
            print("Error parsing JSON:", jsonErr)
        }
        }.resume()
}

func movieIDFromTitle(title: String, year: Int? = nil, completion: @escaping (String) -> () ){
    var ret = "Movie not found"
    OMDBsearchMovieByTitle(imdbTitle: title, releaseYear: year){ (movie) -> () in
        if (movie.imdbID != nil){
            ret = movie.imdbID!
            completion(ret)
        }
    }
}

//OMDBsearchMovieByID(ID: "tt1605783"){ (movie) -> () in //movie is returned movie
//    print (movie.Title!,"\n",movie.Poster!)
//}
//
//OMDBsearchMovieByTitle(imdbTitle: "beauty and the beast", releaseYear: 2017){ (movie) -> () in //movie is returned movie
//    print (movie.Actors!)
//}
//
//movieIDFromTitle(title: "beauty and the beast", year: 2017) { (id) -> () in //id is returned imdbID, year is optional
//    print(id)
//}
