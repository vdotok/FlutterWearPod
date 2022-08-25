//
//  HeartRateModel.swift
//  watch WatchKit Extension
//
//  Created by Taimoor on 27/07/2022.
//

import HealthKit

class HeartRateModel : NSObject{
     var healthStore = HKHealthStore()
        let heartRateQuantity = HKUnit(from: "count/min")
    var heartQuery : HKAnchoredObjectQuery?
    var lastHeartRate : Double = 0.0
    
    override init() {
        super.init()
        start()
    }
    func start() {
//        autorizeHealthKit()
           
       }
//    func autorizeHealthKit() {
//            let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.workoutType()]
//        let healthKitTypesToRead: Set<HKObjectType> = [
//        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
////        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
////                                                        activeEnergy,
////                                                        HKObjectType.workoutType()]
////
////        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
////                                                       bloodType,
////                                                       biologicalSex,
////                                                       bodyMassIndex,
////                                                       height,
////                                                       bodyMass,
////                                                       heartRate,
////                                                       HKObjectType.workoutType()]
//
//        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { [self] success, error in
//
//                if(success){
//                   print("success")
//                    startHeartRateQuery(quantityTypeIdentifier: .heartRate)
//                }else{
//                    print("error")
//                }
//
//            }
//        }
    
    
    func autorizeHealthKit(completion: @escaping (Double?, Error?) -> Void) {
         lastHeartRate = 0.0
        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
    let healthKitTypesToRead: Set<HKObjectType> = [
    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
//        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
//                                                        activeEnergy,
//                                                        HKObjectType.workoutType()]
//
//        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth,
//                                                       bloodType,
//                                                       biologicalSex,
//                                                       bodyMassIndex,
//                                                       height,
//                                                       bodyMass,
//                                                       heartRate,
//                                                       HKObjectType.workoutType()]

        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { [self] success, error in
                
                if(success){
                   print("success")
                    startHeartRateQuery(completion: {value,  error in
                        if(value != nil){
                            completion(value, nil)
                        }else{
                            completion(nil, error)
                        }
                    })
                }else{
                    
                    print("Authorized error", error!)
//                    return ["error": "Authorized Error"]
                    completion(nil, error)
                    
                }
                
            }
        }
    
    
    private func startHeartRateQuery(completion: @escaping (Double?, Error?) -> Void) {
          
          // 1
          let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
          // 2
          let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
              query, samples, deletedObjects, queryAnchor, error in
              
              // 3
          guard let samples = samples as? [HKQuantitySample] else {
              return
          }
              
              self.process(samples, type: .heartRate, completion: { value, error in
                  
                  if((value) != nil){
                      completion(value, nil)
                      
                      return
                  }else{
                      completion(nil, error)
                  }
              })

          }
          
          // 4
        heartQuery = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
          
        heartQuery?.updateHandler = updateHandler
          
          // 5
          
        healthStore.execute(heartQuery!)
      }
      
       func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier, completion: @escaping (Double?, Error?) -> Void) {
          
          
          for sample in samples {
              if type == .heartRate {
                  
                  
                  if(lastHeartRate == 0.0){
                      lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
                      completion(lastHeartRate, nil)
                      
                  }
                  
              }else{
                  completion(nil, nil)
              }
              
//              self.value = Int(lastHeartRate)
          }
      }
  
    
    
}
