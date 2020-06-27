//
//    MapViewController.swift
//     RecycleProject
//

import UIKit
import YandexMapKit
import CoreLocation
import FloatingPanel
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        didSet {
            filterCollectionView.allowsMultipleSelection = true
            filterCollectionView.backgroundColor = .none
        }
    }
    let mapkit = YMKMapKit.sharedInstance()
    let scale = UIScreen.main.scale
    let locationManager = CLLocationManager()
    var recycleStationVC: FloatingPanelController!
    var contentVC: RecycleStationViewController!
    var userLocation: YMKUserLocationLayer!
    var collection: YMKClusterizedPlacemarkCollection!
    var placemarkTapListener: YMKMapObjectTapListener {
        return self
    }
    var stationsArray: [RecycleStation] = [] {
        didSet {
            stations.removeAll()
            for station in stationsArray {
                self.stations[station.location] = station
            }
        }
    }
    var stations: [CLLocationCoordinate2D: RecycleStation] = [:]
    var filteredStationsArray: [RecycleStation] = [] {
        didSet {
            filteredStations.removeAll()
            for station in filteredStationsArray {
                filteredStations[station.location] = station
            }
        }
    }
    var filteredStations: [CLLocationCoordinate2D: RecycleStation] = [:]
    var materialTypesArray: [MaterialType] = []
    var filterSet = Set<MaterialTypeEnumeration>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMaterialTypes()

        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        configureFloatingPanel()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureUserLocation()
        collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        setupMapFocus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard InternetConnectionService.isConnectedToNetwork() else {
            showAlert()
            return
        }
        
        loadPointsFromServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        recycleStationVC?.removePanelFromParent(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func loadPointsFromServer() {
        guard let regionCode = UserDefaults.standard.getRegion()?.code else { return }
        FirebaseService.getData(collectionPath: "Regions/\(regionCode)/Points") { [weak self] (data: [RecycleStation]) in
            guard let self = self else { return }
            self.stationsArray = data
            self.addStationsOnMap()
        }
    }
    
    
    private func fetchMaterialTypes () {
        let fetchRequest: NSFetchRequest<MaterialType> = MaterialType.fetchRequest()
        do {
            materialTypesArray = try CoreDataService.shared.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        filterCollectionView.reloadData()
    }
    
    func addTypeFilter(_ materialType: MaterialTypeEnumeration) {
        filterSet.insert(materialType)
        refreshMap()
    }
    
    func removeTypeFilter(_ materialType: MaterialTypeEnumeration) {
        filterSet.remove(materialType)
        refreshMap()
    }
    
    private func refreshMap() {
        filteredStationsArray.removeAll()
        guard !filterSet.isEmpty else {
            addStationsOnMap()
            return
        }
                
        filteredStationsArray.append(contentsOf: stationsArray.filter {
        for type in filterSet {
            switch type {
            case .plastic:
                guard isContains(array: $0.recycleCodes, in: (1..<10)) else { return false }
            case .glass:
                guard isContains(array: $0.recycleCodes, in: (70..<80)) else { return false }
            case .metal:
                guard isContains(array: $0.recycleCodes, in: (40..<50)) else { return false }
            case .wastepaper:
                guard isContains(array: $0.recycleCodes, in: (20..<30)) else { return false }
            case .other:
                guard isContains(array: $0.recycleCodes, in: (100..<200)) else { return false }
            case .composite:
                guard isContains(array: $0.recycleCodes, in: (80..<90)) else { return false }
            }
        }
            return true
        })
        
        addStationsOnMap()
    }
    
    private func isContains(array: [Int], in interval: Range<Int>) -> Bool {
        return !(array.filter {
            interval.contains($0)
            }).isEmpty
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Нет соединения с интернетом", message: "Карта не будет загружена без подключения к сети", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        okAction.setValue(UIColor(named: "CustomTabBarTintColor"), forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
