//
//  FlutterVdotokWear.swift
//  FlutterVdotokWear
//
//  Created by Taimoor khan on 17/08/2022.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit
class FlutterVdoTokWear: WKInterfaceController, WCSessionDelegate {
    var fromMobile: String = ""
//    private var healthStore = HKHealthStore()
       let heartRateQuantity = HKUnit(from: "count/min")

     private var value = 0
//    @IBOutlet weak var label: WKInterfaceLabel!


    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    //    message come From Mobie
        func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//            self.label.setText(message["counter"] as! String)
            
            print("this is from mobile ", message["counter"] as! String)
            if(message["type"] as! String == "hr"){
                getHeartRate()
            }
            else if(message["type"] as! String == "bo"){
                getBloodOxygen()
            }
            else if(message["type"] as! String == "sc"){
                getStepCounts()
            }else{
                
            }
//            start()
            fromMobile = (message["counter"] as! String)
    //        start()
        }

//    @IBAction func SendToApp() {
//        sendString(text: fromMobile+"from Watch")
//
//    }
    func sendString(text: String){
        print(text)
        let session = WCSession.default;
        if(session.isReachable){
         DispatchQueue.main.async {
                print("Sending counter...")
                session.sendMessage(["counter": text], replyHandler: nil)
            }
        }else{
            print("Watch not reachable...")
        }
    }
 
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if(WCSession.isSupported()){
         let session = WCSession.default;
         session.delegate = self;
         session.activate();
        }

//        label.setText("Taimoor Watch")
    }

  

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
//        start()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }




//    for Sensors data

    func start() {
        getBloodOxygen()
        getHeartRate()
        getStepCounts()
      }
    override func didAppear() {
        start()
//        HeartRateModel.init()
       
    }
  func  getBloodOxygen(){
        let bloodOxygenModel = BloodOxygenModel()
        bloodOxygenModel.autorizeHealthKit(){ value, error in
            
            print("this is oxygen in blood result result",value as Any)
            
        }
    }
    func  getHeartRate(){
          let heartRateModel = HeartRateModel()
        heartRateModel.autorizeHealthKit(){ value, error in
              
            print("this is heartRate result",value as Any)
              
          }
      }
    func getStepCounts(){
        let stepCountModel = StepsCountModel()
        stepCountModel.autorizeHealthKit(completion: {value, error in
            
            print("this is stepCounts ", value as Any)
            
        })
    }

 
 

    


 












    
    
    

    
   

   
}
