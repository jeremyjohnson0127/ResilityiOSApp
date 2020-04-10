//
//  HealthKitManager.swift
//  XenPlux
//
//  Created by rockstar on 3/20/19.
//  Copyright © 2019 MbientLab Inc. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {
    
    public static let sharedInstance = HealthKitManager()
    var healthStore = HKHealthStore()
    let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)

    override init(){
        
    }
    
//    public func fetchHeartRate(complete:@escaping(Double) -> Void, failure:@escaping (Error?) -> Void){
//        if HKHealthStore.isHealthDataAvailable() {
//            self.healthStore = HKHealthStore()
//            self.healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead(), completion: { (success, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    failure(error)
//                } else {
//                    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//                    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
//                    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//                    let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
//                        if let result = results?.first as? HKQuantitySample {
//                            let heartRate = Double(result.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
//                            print("Heart Rate: \(heartRate)bpm")
//                            complete(heartRate)
//                        } else if let error = error {
//                            print("Getting heart rate error: \(error.localizedDescription))")
//                            failure(error)
//                        }
//                    }
//                    self.healthStore.execute(heartRateQuery)
//                }
//            })
//        }
//
//    }
//    
//    
//    public func fetchHRVariablity(complete:@escaping(Double) -> Void, failure:@escaping (Error?) -> Void){
//        if #available(iOS 11.0, *) {
//            let hrvar = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
//            if HKHealthStore.isHealthDataAvailable() {
//                self.healthStore = HKHealthStore()
//                self.healthStore.requestAuthorization(toShare: nil, read: [hrvar], completion: { (success, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        failure(error)
//                    } else {
//                        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
//                        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//                        let heartRateQuery = HKSampleQuery(sampleType: hrvar, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
//                            if let result = results?.first as? HKQuantitySample {
//                                if let heartRate = result.quantity.value(forKey: "value") as? Double {
//                                    print("Heart Rate: \(heartRate)bpm")
//                                    complete(heartRate)
//                                }
//                            } else if let error = error {
//                                print("Getting heart rate error: \(error.localizedDescription))")
//                                failure(error)
//                            }
//                        }
//                        self.healthStore.execute(heartRateQuery)
//                    }
//                })
//            }
//
//        } else {
//            let errorTemp = NSError(domain:"Don't Support HRVR", code:200, userInfo:nil)
//            failure(errorTemp)
//        }
//    }
//    
//    public func fetchRestingHeartRate(complete:@escaping(Double) -> Void, failure:@escaping (Error?) -> Void){
//        if #available(iOS 11.0, *) {
//            let resting = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
//            if HKHealthStore.isHealthDataAvailable() {
//                self.healthStore = HKHealthStore()
//                self.healthStore.requestAuthorization(toShare: nil, read: [resting], completion: { (success, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        failure(error)
//                    } else {
//                        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
//                        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//                        let heartRateQuery = HKSampleQuery(sampleType: resting, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
//                            if let result = results?.first as? HKQuantitySample {
//                                if let heartRate = result.quantity.value(forKey: "value") as? Double {
//                                    print("Heart Rate: \(heartRate)bpm")
//                                    complete(heartRate)
//                                }
//                            } else if let error = error {
//                                print("Getting heart rate error: \(error.localizedDescription))")
//                                failure(error)
//                            } else {
//                                complete(0)
//                            }
//                        }
//                        self.healthStore.execute(heartRateQuery)
//                    }
//                })
//            }
//            
//        } else {
//            let errorTemp = NSError(domain:"Don't Support Resting", code:200, userInfo:nil)
//            failure(errorTemp)
//        }
//    }
//    


    
    private func dataTypesToRead() -> Set<HKObjectType> {
        
        let dietaryCalorieEnergyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let birthdayType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType)!
        let fitzpatrickSkinType = HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        let bloodPressureSystolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let bloodPressureDiastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let oxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType,heightType,weightType,birthdayType,biologicalSexType,bloodType,fitzpatrickSkinType, heartRateType,sleepAnalysisType,stepCountType,bloodGlucoseType,bloodPressureSystolicType,bloodPressureDiastolicType,oxygenType]
        return readDataTypes
    }

    func retrieveMindFulMinutes(complete:@escaping(Double) -> Void, failure:@escaping (Error?) -> Void) {
        
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            self.healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead(), completion: { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    failure(error)
                } else {
                    let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
                    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
                    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                    let mindfulQuery = HKSampleQuery(sampleType: mindfulType!, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
                        
                        if error != nil {
                            print("Getting mindful error: \(error?.localizedDescription))")
                            failure(error)
                        }
                        let totalMeditationTime = results?.map(self.calculateTotalTime).reduce(0, { $0 + $1 }) ?? 0
                        print("Heart Rate: \(totalMeditationTime)")
                        complete(totalMeditationTime)
                    }
                    self.healthStore.execute(mindfulQuery)
                }
            })
        }
    }
    
    
    func activateHealthKit() {
        // Define what HealthKit data we want to ask to read
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Define what HealthKit data we want to ask to write
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Prompt the User for HealthKit Authorization
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if !success{
                print("HealthKit Auth error\(error)")
            }
            self.retrieveMindFulMinutes()
        }
    }
    
    func calculateTotalTime(sample: HKSample) -> TimeInterval {
        let totalTime = sample.endDate.timeIntervalSince(sample.startDate)
        let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false
        
        print("\nHealthkit mindful entry: \(sample.startDate) \(sample.endDate) - value: \(totalTime) quantity: \(totalTime) user entered: \(wasUserEntered)\n")
        
        return totalTime
    }
    
    func updateMeditationTime(query: HKSampleQuery, results: [HKSample]?, error: Error?) {
        if error != nil {return}
        
        // Sum the meditation time
        let totalMeditationTime = results?.map(calculateTotalTime).reduce(0, { $0 + $1 }) ?? 0
        
        print("\n Total: \(totalMeditationTime)")
        
        renderMeditationMinuteText(totalMeditationSeconds: totalMeditationTime)
        
    }
    
    func renderMeditationMinuteText(totalMeditationSeconds: Double) {
        
        let minutes = Int(totalMeditationSeconds / 60)
        
//        let labelText = "\(minutes) Mindful Minutes in the last 24 hours"
//        DispatchQueue.main.async {
//            self.meditationMinutesLabel.text = labelText
//        }
    }
    
    func retrieveMindFulMinutes() {
        
        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // Create the HealthKit Query
        let query = HKSampleQuery(
            sampleType: mindfulType!,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor],
            resultsHandler: updateMeditationTime
        )
        // Execute our query
        healthStore.execute(query)
    }
    
    func saveMindfullAnalysis(startTime: Date, endTime: Date) {
        // Create a mindful session with the given start and end time
        
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Define what HealthKit data we want to ask to write
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
            ])
        
        // Prompt the User for HealthKit Authorization
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if !success{
                print("HealthKit Auth error\(error)")
            }
            let mindfullSample = HKCategorySample(type:self.mindfulType!, value: 0, start: startTime, end: endTime)
            // Save it to the health store
            self.healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
                if error != nil {
                    print("failed to save mindful")
                    return
                }
                print("New data was saved in HealthKit: \(success)")
                self.retrieveMindFulMinutes()
            })
        }

    }


}
