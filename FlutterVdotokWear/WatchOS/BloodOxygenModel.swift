
import HealthKit

class BloodOxygenModel : NSObject{
     var healthStore = HKHealthStore()
    let osUnit:HKUnit = HKUnit(from: "%")
    
    override init() {
        super.init()
    }

    func autorizeHealthKit(completion: @escaping (Double?, Error?) -> Void) {
            let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]

        healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { [self] success, error in
                
                if(success){
                   print("success")
//                    startHeartRateQuery(quantityTypeIdentifier: .heartRate)
                    getOxygenLevel(completion: {value,error in
                        if((value) != nil){
                            completion(value, nil)
                        }else{
                            print("not able to get sensors data", error!)
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
    

    
    public func getOxygenLevel(completion: @escaping (Double?, Error?) -> Void) {

        guard let oxygenQuantityType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else {
            fatalError("*** Unable to get oxygen saturation on this device ***")
        }
                    
            let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
            let query = HKStatisticsQuery(quantityType: oxygenQuantityType,
                                          quantitySamplePredicate: predicate,
                                          options: .mostRecent) { query, result, error in
                
                DispatchQueue.main.async {
                    
                    if let err = error {
                        completion(nil, err)
                    } else {
                        guard let level = result, let sum = level.mostRecentQuantity() else {
                            completion(nil, error)
                            return
                        }
                        print("Quantity : ", sum)   // It prints 97 % and I need 97 only
                        
                        let measureUnit0 = HKUnit(from: "%")
                        let count0 = sum.doubleValue(for: measureUnit0)
                        print("Count 0 : ", count0)   // It pronts 0.97 and I need 97 only
                        
                        let measureUnit1 = HKUnit.count().unitMultiplied(by: HKUnit.percent())
                        let count1 = sum.doubleValue(for: measureUnit1)
                        print("Count 1 : ", count1)   // It pronts 0.97 and I need 97 only
                        
                        let measureUnit2 = HKUnit.percent()
                        let count2 = sum.doubleValue(for: measureUnit2)
                        print("Count 2 : ", count2)   // It pronts 0.97 and I need 97 only

                        let measureUnit3 = HKUnit.count()
                        let count3 = sum.doubleValue(for: measureUnit3)
                        print("Count 3 : ", count3)   // It pronts 0.97 and I need 97 only

                        completion(count0 * 100.0, nil)
                    }
                }
            }
            HKHealthStore().execute(query)
        }
    
  
    
    
}
