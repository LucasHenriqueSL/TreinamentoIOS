//
//  HomeViewController.swift
//  TreinamentoIOS
//
//  Created by COTEMIG on 16/10/21.
//

import UIKit
import Kingfisher



extension UIImage {
    /// Inverts the colors from the current image. Black turns white, white turns black etc.
    func invertedColors() -> UIImage? {
        guard let ciImage = CIImage(image: self) ?? ciImage, let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = filter.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }
}


public enum Genre: Int, Equatable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case science = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
    
    func description() -> String {
        switch self {
        case .action: return "Ação"
        case .adventure: return "Aventura"
        case .animation: return "Animação"
        case .comedy: return "Comédia"
        case .crime: return "Crime"
        case .documentary: return "Documentário"
        case .drama: return "Drama"
        case .family: return "Família"
        case .fantasy: return "Fantasia"
        case .history: return "História"
        case .horror: return "Terror"
        case .music: return "Música"
        case .mystery: return "Suspense"
        case .romance: return "Romance"
        case .science: return "Fição Científica"
        case .tvMovie: return "TV Filme"
        case .thriller: return "Ação"
        case .war: return "Guerra"
        case .western: return "Faroeste"
            
        }
    }
    
}


public enum Constants: String{
    case apiKey = "04787e0fbde2b036ed54eb516b003bfa"
    case baseURL = "https://api.themoviedb.org/3"
    case popularURL = "/movie/popular"
    case imageURL = "https://image.tmdb.org/t/p/w500"
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movieList: [Movie] = []
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getMovies()
        //movieList.append(contentsOf: [Movie(name:"Homem Aranha", sinopse: "Um homem foi picado por uma aranha e ganhou poderes"),Movie(name:"Homem De Ferro", sinopse: "Um homem foi picado por um ferro e ganhou poderes"),Movie(name:"Vingadores", sinopse: "Os super heróis mais brabos lutando contra o mau")])
        
        
    }
    
    func getMovies(){
        //https://api.themoviedb.org/3/movie/popular?api_key=04787e0fbde2b036ed54eb516b003bfa
        let url = URL(string: Constants.baseURL.rawValue +
                        Constants.popularURL.rawValue +
                        "?api_key=" + Constants.apiKey.rawValue)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movieListJson = try JSONDecoder().decode(ResponseData.self, from: data)
                    self.movieList = movieListJson.movies
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print("Falha em converter json")
                }
            }
        }.resume()
    }
    
    func getMoviesDetails(id: Int){
        //https://api.themoviedb.org/3/movie/popular?api_key=04787e0fbde2b036ed54eb516b003bfa
        let url = URL(string: Constants.baseURL.rawValue +
                        Constants.popularURL.rawValue +
                        "?api_key=" + Constants.apiKey.rawValue)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movieListJson = try JSONDecoder().decode(ResponseData.self, from: data)
                    self.movieList = movieListJson.movies
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print("Falha em converter json")
                }
            }
        }.resume()
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        let movie = sender as! Movie
        detailViewController.movie = movie
    }
    
    //Quantidade de itens que minha lista vai mostrar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    //layout da célula de propt[otipo
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movieName = movieList[indexPath.row]
        
        cell.generos.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        cell.generosBaixo.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let image = UIImage(named: "favorito_on")!
        
        if traitCollection.userInterfaceStyle == .light {
            cell.imageMovie.image = image
        } else {
            cell.imageMovie.image = image.invertedColors()
        }
        
        
        cell.movieName.text = movieName.title
        cell.movieDescription.text = movieName.releaseDate
        cell.numberLabel.text = "\(indexPath.row + 1)"
        for (index, item) in movieName.genreIDS.enumerated(){
            if (index < 3) {
                let generoName =  Genre(rawValue: item)?.description()
                let genreview = createGeneroView(with: generoName ?? "-")
                cell.generos.addArrangedSubview(genreview)
            }else{
                let generoName =  Genre(rawValue: item)?.description()
                let genreview = createGeneroView(with: generoName ?? "-")
                cell.generosBaixo.addArrangedSubview(genreview)
                
            }
            
        }
        
//
//        let generoView = createGeneroView(with: "Aventura")
//        let genero1View = createGeneroView(with: "Ação")
//        let genero2View = createGeneroView(with: "Terror")
//
//
//        cell.generos.addArrangedSubview(generoView)
//        cell.generos.addArrangedSubview(genero1View)
//        cell.generos.addArrangedSubview(genero2View)
        
        
        //        let dramaView = createGeneroView(with: "Drama")
        //        cell.generosBaixo.addArrangedSubview(dramaView)
        
        
        
        let imagePath = Constants.imageURL.rawValue + movieName.posterPath
        if let imageURL = URL(string: imagePath) {
            cell.imageMovie.kf.setImage(with: imageURL)
        }
        
        return cell
    }

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        updateImageForCurrentTraitCollection()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row]
        performSegue(withIdentifier: "ShowDetailScreen", sender: movie)
    }
    
    private func createGeneroView(with title: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        
        view.addSubview(label)
        
        view.addConstraints([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.0),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4.0),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.0)
        ])
        
        return view
    }
    
}
