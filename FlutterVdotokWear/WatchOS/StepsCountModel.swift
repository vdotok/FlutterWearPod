
import HealthKit

class StepsCountModel : NSObject{
     var healthStore = HKHealthStore()
    
    override init() {
        super.init()
    }
    
    
    func autorizeHealthKit(completion: @escaping (Int?, Error?) -> Void) {

        // Access Step Count
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { [self] (success, error) in
            if (success) {
                // Authorization Successful
                getSteps(completion: {value, error in
                    
                    if(value != nil){
                        let stepCount = Int(value!)
                        completion(stepCount, nil)
                    }else{
                        completion(nil, error)
                    }
                    
                })
//                { (result) in
//                    DispatchQueue.main.async {
//                        let stepCount = Int(result)
//                        print("these are stepCount", stepCount)
//                        completion()
////                          self.stepsLabel.text = String(stepCount)
//                    }
//                }
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
  func getSteps(completion: @escaping (Double?, Error?) -> Void){
      let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
      let now = Date()
      let startOfDay = Calendar.current.startOfDay(for: now)
      var interval = DateComponents()
      interval.day = 1

      let query = HKStatisticsCollectionQuery(
           quantityType: stepsQuantityType,
           quantitySamplePredicate: nil,
           options: [.cumulativeSum],
           anchorDate: startOfDay,
           intervalComponents: interval)


      query.initialResultsHandler = { _, result, error in
          if(result != nil){
              var resultCount = 0.0
              result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
              if let sum = statistics.sumQuantity() {
                  // Get steps (they are of double type)
                  resultCount = sum.doubleValue(for: HKUnit.count())
              }
                
                  completion(resultCount, nil)
                  // end if
              // Return
//              DispatchQueue.main.async {
//                  completion(resultCount)
//              }
          }
          }else {
              completion(nil, error)
              
          }
              
      }

      query.statisticsUpdateHandler = {
          query, statistics, statisticsCollection, error in
          // If new statistics are available
         
          if let sum = statistics?.sumQuantity() {
              let resultCount = sum.doubleValue(for: HKUnit.count())
              completion(resultCount, nil)
              // Return
//              DispatchQueue.main.async {
//                  completion(resultCount, )
//              }
          } else{
              completion(nil, error)
          }// end if
      }

      healthStore.execute(query)

  }

    
    
    
  
  
    
    
}
