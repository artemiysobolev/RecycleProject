//
//	CoreDataService.swift
// 	RecycleProject
//

import UIKit
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}
    
    var context: NSManagedObjectContext!
    
    func getDataFromFile() {
        
        getMaterialTypes()
        getMaterial(fileName: "Plastic", typeName: "Пластик")
        getMaterial(fileName: "Wastepaper", typeName: "Макулатура")
        getMaterial(fileName: "Glass", typeName: "Стекло")
        getMaterial(fileName: "Metal", typeName: "Металл")
        getMaterial(fileName: "Composite", typeName: "Смешанные материалы")
        getMaterial(fileName: "Other", typeName: "Другие")
    }
    
    
    private func getMaterialTypes() {
        guard let path = Bundle.main.path(forResource: "MaterialTypes", ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else { return }
        
        for dict in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "MaterialType", in: context) else { return }
            guard let materialType = NSManagedObject(entity: entity, insertInto: context) as? MaterialType else { return }
            
            let materialTypeDict = dict as! [String: AnyObject]
            
            guard let materialTypeName = materialTypeDict["name"] as? String,
                let imageName = materialTypeDict["imageName"] as? String,
                let colorName = materialTypeDict["colorName"] as? String,
                let image = UIImage(named: imageName),
                let imageData = image.pngData() else { return }
            
            materialType.name = materialTypeName
            materialType.imageData = imageData
            materialType.colorName = colorName
            
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getMaterial(fileName: String, typeName: String) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let dataArray = NSArray(contentsOfFile: path) else  { return }
        
        for dict in dataArray {
            guard let entity = NSEntityDescription.entity(forEntityName: "Material", in: context) else { return }
            guard let material = NSManagedObject(entity: entity, insertInto: context) as? Material else { return }
            
            let materialDict = dict as! [String: AnyObject]
            
            material.code = materialDict["code"] as? Int16 ?? 0
            material.shortName = materialDict["shortName"] as? String
            material.fullName = materialDict["fullName"] as? String
            material.shortDesctiption = materialDict["shortDescription"] as? String
            material.fullDescription = materialDict["fullDescription"] as? String
            material.anotherNames = materialDict["anotherNames"] as? String
            material.examples = materialDict["examples"] as? String
            material.howToPrepare = materialDict["howToPrepare"] as? String
            material.numberOfRecyclePoints = materialDict["numberOfRecyclePoints"] as? Int16 ?? 0
            if let imageName = materialDict["imageName"] as? String,
                let image = UIImage(named: imageName),
                let imageData = image.pngData() {
                material.imageData = imageData
            }
            
            
            let fetchRequest: NSFetchRequest<MaterialType> = MaterialType.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", typeName)
            
            do {
                let materialType = try context.fetch(fetchRequest).first
                materialType?.addToMaterials(material)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
