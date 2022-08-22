//
//  VdotokWear.swift
//  FlutterWear
//
//  Created by Taimoor khan on 18/08/2022.
//

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
 
    }
    

    
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

            print("this is from mobile ",  message["type"] as! String)
            if(message["type"] as! String == "hr"){
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .heartRate)!
                
                let flag : Bool =   hasPermission(type: type, access: 1)!
                print("thsi is flag ", flag)
                
                if(flag){
                    getHeartRate()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                    
                }
                
            }
            else if(message["type"] as! String == "bo"){
                
                
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!
                
                let flag : Bool =   hasPermission(type: type, access: 1)!
                print("thsi is flag ", flag)
                
                if(flag){
                    getBloodOxygen()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                    
                }
                  
            }
            else if(message["type"] as! String == "sc"){
                
                let type : HKSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
                
                let flag : Bool =   hasPermission(type: type, access: 1)!
                print("thsi is flag ", flag)
                
                if(flag){
                    getStepCounts()
                }else{
                    sendString(text: "Permission not granted" , messgaeType: "message")
                }
                
            }else{

            }

        }
    
    
    func sendString(text: String, messgaeType: String){

        if(wcSession!.isReachable){
            DispatchQueue.main.async { [self] in
                print("Sending counter...")
             wcSession!.sendMessage([messgaeType: text], replyHandler: nil)
            }
        }else{
            print("Watch not reachable...")
        }
    }
    
    func  getBloodOxygen(){
          let bloodOxygenModel = BloodOxygenModel()
        bloodOxygenModel.autorizeHealthKit(){ [self] value, error in
              if(value != nil){
                  sendString(text: String(format: "%f", value!) , messgaeType: "hr")

              }else{
                  sendString(text: "Something went wrong " , messgaeType: "message")
              }
              
              
          }
      }
      func  getHeartRate(){
            let heartRateModel = HeartRateModel()
          heartRateModel.autorizeHealthKit(){ [self] value, error in
              if(value != nil){
                  sendString(text: String(format: "%f", value!) , messgaeType: "bo")
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
    
    
    
    func hasPermission(type: HKSampleType, access: Int) -> Bool? {
        
        if #available(iOS 13.0, *) {
            let status = healthStore.authorizationStatus(for: type)
            switch access {
            case 0: // READ
                return nil
            case 1: // WRITE
                return  (status == HKAuthorizationStatus.sharingAuthorized)
            default: // READ_WRITE
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    
}
