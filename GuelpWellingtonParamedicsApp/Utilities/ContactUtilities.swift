//
//  ContactUtilities.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-29.
//

import Foundation

class ContactUtilities {
    static func initialStaticData() -> [Department] {
        
        let services = ["CHAP", "LTC", "FLU", "COVID", "PAD"]
        // for program coordination deparment
        let leanne = ParamedicContact(
            person: "Leanne Swantko",
            email: "leanne.swantko@guelph.ca",
            homePhoneNo: "",
            ext: "2105",
            workPhoneNo: "519-993-5775",
            personalPhoneNo: "519-651-0970",
            services: services,
            availableServices: ["CHAP"])
        
        let brad = ParamedicContact(
            person: "Brad Jackson",
            email: "brad.jackson@guelph.ca",
            homePhoneNo: "",
            ext: "3379",
            workPhoneNo: "226-962-4713",
            personalPhoneNo: "519-321-0325",
            services: services,
            availableServices: services)
        
        let emily = ParamedicContact(
            person: "Emily Cooper",
            email: "emily.cooper@guelph.ca",
            homePhoneNo: "",
            ext: "3379",
            workPhoneNo: "226-962-4715",
            personalPhoneNo: "519-212-1189",
            services: services,
            availableServices: services)
        
        let amy = ParamedicContact(
            person: "Amy Courtney",
            email: "amy.courtney@guelph.ca",
            homePhoneNo: "",
            ext: "3379",
            workPhoneNo: "519-820-2507",
            personalPhoneNo: "519-212-5120",
            services: services,
            availableServices: ["CHAP"])
        
        let andrea = ParamedicContact(
            person: "Andrea Ieropoli",
            email: "andrea.ieropoli@guelph.ca",
            homePhoneNo: "",
            ext: "3379",
            workPhoneNo: "519-820-2176",
            personalPhoneNo: "",
            services: services,
            availableServices: [""])
        
        let programCoordinationDepartment = Department(
            name: "Coordination",
            contacts: [leanne, brad, emily, amy, andrea],
            email: "PS-ES-EMS-CPCoordinators@guelph.ca")
        
        // for community paramedic department
        let amyBenn = ParamedicContact(
            person: "Amy Benn",
            email: "amy.benn@guelph.ca",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "",
            personalPhoneNo: "519-313-0490",
            services: services,
            availableServices: services)
        
        let kimGlover = ParamedicContact(
            person: "Kim Glover",
            email: "kim.glover@guelph.ca",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "",
            personalPhoneNo: "519-939-0619",
            services: services,
            availableServices: ["LTC", "COVID"])
        
        let derek = ParamedicContact(
            person: "Derek Bridgwater",
            email: "derek.bridgwater@guelph.ca",
            homePhoneNo: "519-323-3526",
            ext: "",
            workPhoneNo: "",
            personalPhoneNo: "519-323-8254",
            services: services,
            availableServices: ["LTC", "FLU", "COVID"])
        
        let communityParamedicDepartment = Department(
            name: "Community Paramedic",
            contacts: [amyBenn, kimGlover, derek],
            email: "PS-ES-EMS-CommunityParamedics@guelph.ca")
        
        // for PAD specialist deparment
        let mike = ParamedicContact(
            person: "Mike Dick",
            email: "mick.dick@guelph.ca",
            homePhoneNo: "519-343-3891",
            ext: "3379",
            workPhoneNo: "",
            personalPhoneNo: "519-291-8020",
            services: services,
            availableServices: ["COVID", "PAD"])
        
        let dwayne = ParamedicContact(
            person: "Dwayne Buhrow",
            email: "dwayne.buhrow@guelph.ca",
            homePhoneNo: "519-846-1756",
            ext: "3379",
            workPhoneNo: "",
            personalPhoneNo: "519-212-0232",
            services: services,
            availableServices: ["PAD"])
        
        let amyBen = ParamedicContact(
            person: "Amy Benn",
            email: "amy.benn@guelph.ca",
            homePhoneNo: "519-846-1756",
            ext: "3379",
            workPhoneNo: "",
            personalPhoneNo: "519-313-0490",
            services: services,
            availableServices: services)
        
        let padSpecialistDepartment = Department(
            name: "PAD Specialist",
            contacts: [mike, dwayne, amyBen],
            email: "PAD@guelph.ca")
        
        // for CP office
        let cpOffice = ParamedicContact(
            person: "CP Office",
            email: "",
            homePhoneNo: "",
            ext: "3379",
            workPhoneNo: "519-822-1260",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let cpOfficeDeparment = Department(
            name: "CP Office",
            contacts: [cpOffice],
            email: "communityparamedic@guelph.ca")
        
        // for CP South
        let southFax = ParamedicContact(
            person: "South Fax",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "519-840-2565",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let southCP = ParamedicContact(
            person: "South CP (#1)",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "519-546-5970",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let cpResourceNight = ParamedicContact(
            person: "CP Resource Night (#2)",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "519-546-5412",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let pad_clinic_cpResourceD = ParamedicContact(
            person: "PAD/Clinic/CP Resource D (#3)",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "226-962-3460",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let cpSouthDepartment = Department(
            name: "CP South",
            contacts: [southFax, southCP, cpResourceNight, pad_clinic_cpResourceD],
            email: "")
        
        // for CP North
        let northFax = ParamedicContact(
            person: "North Fax",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "519-338-3121",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let northCP = ParamedicContact(
            person: "North CP (7-19) (#4)",
            email: "",
            homePhoneNo: "",
            ext: "",
            workPhoneNo: "226-821-5007",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let doorCode = ParamedicContact(
            person: "Door Code",
            email: "",
            homePhoneNo: "",
            ext: "541*",
            workPhoneNo: "",
            personalPhoneNo: "",
            services: [],
            availableServices: [])
        
        let cpNorthDepartment = Department(
            name: "CP North",
            contacts: [northFax, northCP, doorCode],
            email: "")
        
        let departments = [
            programCoordinationDepartment,
            communityParamedicDepartment,
            padSpecialistDepartment,
            cpOfficeDeparment,
            cpSouthDepartment,
            cpNorthDepartment
        ]
        
        return departments
    }
}
