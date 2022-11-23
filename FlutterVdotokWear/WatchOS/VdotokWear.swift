
import WatchKit
import Foundation
import WatchConnectivity
import HealthKit
public class VdoTokWear: NSObject, WCSessionDelegate {
    var healthStore = HKHealthStore()
    var fromMobile: String = ""
//    private var healthStore = HKHealthStore()
       let heartRateQuantity = HKUnit(from: "count/min")

     private var value = 0
    
    var wcSession : WCSession? = nil
    public override init() {
      
        wcSession = WCSession.default
       
        super.init()
        wcSession?.delegate = self
        wcSession?.activate()
        let getPermissions = GetPermissions()
        getPermissions.autorizeHealthKit(){ [self] value, error in
            if(value != nil){
                //                sendString(text: String(format: "%f", value!) , messgaeType: "bo")
                
            }else{
                sendString(text: "Something went wrong " , messgaeType: "message")
            }
            
        }
 
    }
    

    
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

            print("this is from mobile ",  message["type"] as! String)
            if(message["type"] as! String == "hr"){
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .heartRate)!
                
                let status : HKAuthorizationStatus =   hasPermission(type: type, access: 1)!
//                print("thsi is flag ", flag)
                
                if(status == HKAuthorizationStatus.notDetermined || status == HKAuthorizationStatus.sharingAuthorized){
                    getHeartRate()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                }
                
            }
            else if(message["type"] as! String == "bo"){
                
                
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!
                
                let status : HKAuthorizationStatus =   hasPermission(type: type, access: 1)!
//                print("thsi is flag ", flag)
                
                if(status == HKAuthorizationStatus.notDetermined || status == HKAuthorizationStatus.sharingAuthorized){
                    getBloodOxygen()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                    
                }
                  
            }
            else if(message["type"] as! String == "sc"){
                
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
                
                let status : HKAuthorizationStatus =   hasPermission(type: type, access: 1)!
//                print("thsi is flag ", flag)
                
                if(status == HKAuthorizationStatus.notDetermined || status == HKAuthorizationStatus.sharingAuthorized){
                    getStepCounts()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                }
                
            }else{

            }

        }
    
    
    func sendString(text: String, messgaeType: String){

        if(wcSession!.isReachable){
            DispatchQueue.main.async { [self] in             wcSession!.sendMessage([messgaeType: text], replyHandler: nil)
            }
        }else{
            print("phone not reachable...")
//            sendString(text: "Phone not reachable...Please turn on your watch display" , messgaeType: "message")
        }
    }
    
    func  getBloodOxygen(){
          let bloodOxygenModel = BloodOxygenModel()
        bloodOxygenModel.autorizeHealthKit(){ [self] value, error in
              if(value != nil){
                  sendString(text: String(format: "%f", value!) , messgaeType: "bo")

              }else{
                  sendString(text: "Something went wrong " , messgaeType: "message")
              }
              
              
          }
      }
      func  getHeartRate(){
            let heartRateModel = HeartRateModel()
          heartRateModel.autorizeHealthKit(){ [self] value, error in
              if(value != nil){
                  sendString(text: String(format: "%f", value!) , messgaeType: "hr")
              }else{
                  sendString(text: "Something went wrong  " , messgaeType: "message")
              }
             
                
            }
        }
      func getStepCounts(){
          let stepCountModel = StepsCountModel()
          stepCountModel.autorizeHealthKit(completion: { [self]value, error in
              
              if(value != nil){
                  sendString(text: String(value!) , messgaeType: "sc")
              }else{
                  sendString(text: "Something went wrong  " , messgaeType: "message")
              }
              
          })
      }
    
    
    
    func hasPermission(type: HKSampleType, access: Int) -> HKAuthorizationStatus? {
        
        if #available(iOS 13.0, *) {
            let status = healthStore.authorizationStatus(for: type)
           
            
            switch access {
            case 0: // READ
                return nil
            case 1: // WRITE
                return  status
            default: // READ_WRITE
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    
}
