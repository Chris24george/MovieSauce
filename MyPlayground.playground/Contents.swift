//: Playground - noun: a place where people can play

import UIKit

import Foundation
import PlaygroundSupport

var baseUrlString = "http://www.omdbapi.com/?apikey=21f0a994&i=tt1270797"

func searchMovieById (imdbId: String) -> String {
    let url = URL(string: baseUrlString)
    print("before task")
    let session = URLSession.shared
    let task = session.dataTask(with: url!) {(data, response, error) in
        print("in task")
        if error == nil {
            let dataString = String(decoding: data!, as: UTF8.self)
            print(dataString)
        } else {
            print("something went wrong")
        }
    }.resume()
    return ""
}


searchMovieById(imdbId: "tt1270797")




PlaygroundPage.current.needsIndefiniteExecution = true

