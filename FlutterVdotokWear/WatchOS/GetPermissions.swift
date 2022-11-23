//
//  GetPermissions.swift
//  FlutterVdotokWear
//
//  Created by Taimoor khan on 23/11/2022.
//



import HealthKit

class GetPermissions : NSObject{
     var healthStore = HKHealthStore()
    
    override init() {
        super.init()
    }
    
    
    func autorizeHealthKit(completion: @escaping (Int?, Error?) -> Void) {

        // Access Step Count
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)! ]
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) {  (success, error) in
            if (success) {
                completion(1, nil)
                // Authorization Successful
//                getSteps(completion: {value, error in
//
//                    if(value != nil){
//                        let stepCount = Int(value!)
//                        completion(stepCount, nil)
//                    }else{
//                        completion(nil, error)
//                    }
//
//                })
//                { (result) in
//                    DispatchQueue.main.async {
//                        let stepCount = Int(result)
//                        print("these are stepCount", stepCount)
//                        completion()
////                          self.stepsLabel.text = String(stepCount)
//                    }
//                }
            }else{
                completion(nil, error)
            } // end if
        }


//          let healthKitTypes: Set = [
//          HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
//
//          healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes,
//                                           completion: { [self] (success, error) -> Void in
//
//              if error != nil
//              {
//                  print("error \(error?.localizedDescription)")
//              }
//              else if success
//              {
//                 print("success")
//                  startHeartRateQuery(quantityTypeIdentifier: .heartRate)
//              }
//          })
    }
  
    
    
    
  
  
    
    
}

