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
    var stationsArray: [RecycleStation] = []
    var stations: [CLLocationCoordinate2D: RecycleStation] = [:]
    var filteredStationsArray: [RecycleStation] = []
    var filteredStations: [CLLocationCoordinate2D: RecycleStation] = [:]
    var materialTypesArray: [MaterialType] = []
    var filterSet = Set<MaterialTypeEnumeration>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMaterialTypes()

        guard InternetConnectionService.isConnectedToNetwork() else {
            showAlert()
            return
        }
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        configureFloatingPanel()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureUserLocation()
        collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        loadPointsFromServer()
        setupMapFocus()
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
            for station in data {
                self.stations[station.location] = station
            }
            self.addStationsOnMap(self.stations)
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
    
    internal func addTypeFilter(_ materialType: MaterialTypeEnumeration) {
        filterSet.insert(materialType)
        refreshMap()
    }
    
    internal func removeTypeFilter(_ materialType: MaterialTypeEnumeration) {
        filterSet.remove(materialType)
        refreshMap()
    }
    
    private func refreshMap() {
        guard !filterSet.isEmpty else {
            addStationsOnMap(stations)
            return
        }
        
        filteredStationsArray.removeAll()
        filteredStations.removeAll()
        
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
        
//        filteredStationsArray.append(contentsOf: stationsArray.filter {
//            if filterSet.contains(.plastic) {
//                guard isContains(array: $0.recycleCodes, in: (1..<10)) else { return false }
//            } else if filterSet.contains(.wastepaper) {
//                guard isContains(array: $0.recycleCodes, in: (20..<30)) else { return false }
//            } else if filterSet.contains(.metal) {
//                guard isContains(array: $0.recycleCodes, in: (40..<50)) else { return false }
//            } else if filterSet.contains(.glass) {
//                guard isContains(array: $0.recycleCodes, in: (70..<80)) else { return false }
//            } else if filterSet.contains(.composite) {
//                guard isContains(array: $0.recycleCodes, in: (80..<90)) else { return false }
//            } else if filterSet.contains(.other) {
//                guard isContains(array: $0.recycleCodes, in: (100..<200)) else { return false }
//            }
//            return true
//        })
        
        for station in filteredStationsArray {
            filteredStations[station.location] = station
        }
        addStationsOnMap(filteredStations)
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
