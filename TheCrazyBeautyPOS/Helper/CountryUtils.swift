//
//  CountryUtils.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 02/07/25.
//

import Foundation

struct CountryUtils {
    
    // MARK: - Dial Code to ISO Mapping
    static let dialCodeToISO: [String: String] = [
        "+1": "US",    // USA, Canada, others under NANP
        "+7": "RU",    // Russia
        "+20": "EG",   // Egypt
        "+27": "ZA",   // South Africa
        "+30": "GR",   // Greece
        "+31": "NL",   // Netherlands
        "+32": "BE",   // Belgium
        "+33": "FR",   // France
        "+34": "ES",   // Spain
        "+36": "HU",   // Hungary
        "+39": "IT",   // Italy
        "+41": "CH",   // Switzerland
        "+44": "GB",   // United Kingdom
        "+49": "DE",   // Germany
        "+52": "MX",   // Mexico
        "+55": "BR",   // Brazil
        "+61": "AU",   // Australia
        "+62": "ID",   // Indonesia
        "+63": "PH",   // Philippines
        "+64": "NZ",   // New Zealand
        "+65": "SG",   // Singapore
        "+66": "TH",   // Thailand
        "+81": "JP",   // Japan
        "+82": "KR",   // South Korea
        "+84": "VN",   // Vietnam
        "+86": "CN",   // China
        "+90": "TR",   // Turkey
        "+91": "IN",   // India
        "+92": "PK",   // Pakistan
        "+93": "AF",   // Afghanistan
        "+94": "LK",   // Sri Lanka
        "+95": "MM",   // Myanmar
        "+98": "IR",   // Iran
        "+212": "MA",  // Morocco
        "+213": "DZ",  // Algeria
        "+216": "TN",  // Tunisia
        "+218": "LY",  // Libya
        "+220": "GM",  // Gambia
        "+221": "SN",  // Senegal
        "+222": "MR",  // Mauritania
        "+223": "ML",  // Mali
        "+224": "GN",  // Guinea
        "+225": "CI",  // Côte d’Ivoire
        "+226": "BF",  // Burkina Faso
        "+227": "NE",  // Niger
        "+228": "TG",  // Togo
        "+229": "BJ",  // Benin
        "+230": "MU",  // Mauritius
        "+231": "LR",  // Liberia
        "+232": "SL",  // Sierra Leone
        "+233": "GH",  // Ghana
        "+234": "NG",  // Nigeria
        "+235": "TD",  // Chad
        "+236": "CF",  // Central African Republic
        "+237": "CM",  // Cameroon
        "+238": "CV",  // Cape Verde
        "+239": "ST",  // São Tomé & Príncipe
        "+240": "GQ",  // Equatorial Guinea
        "+241": "GA",  // Gabon
        "+242": "CG",  // Republic of the Congo
        "+243": "CD",  // DR Congo
        "+244": "AO",  // Angola
        "+245": "GW",  // Guinea-Bissau
        "+246": "IO",  // British Indian Ocean Territory
        "+247": "AC",  // Ascension Island
        "+248": "SC",  // Seychelles
        "+249": "SD",  // Sudan
        "+250": "RW",  // Rwanda
        "+251": "ET",  // Ethiopia
        "+252": "SO",  // Somalia
        "+253": "DJ",  // Djibouti
        "+254": "KE",  // Kenya
        "+255": "TZ",  // Tanzania
        "+256": "UG",  // Uganda
        "+257": "BI",  // Burundi
        "+258": "MZ",  // Mozambique
        "+260": "ZM",  // Zambia
        "+261": "MG",  // Madagascar
        "+262": "RE",  // Réunion (France)
        "+263": "ZW",  // Zimbabwe
        "+264": "NA",  // Namibia
        "+265": "MW",  // Malawi
        "+266": "LS",  // Lesotho
        "+267": "BW",  // Botswana
        "+268": "SZ",  // Eswatini
        "+269": "KM",  // Comoros
        "+290": "SH",  // Saint Helena
        "+291": "ER",  // Eritrea
        "+297": "AW",  // Aruba
        "+298": "FO",  // Faroe Islands
        "+299": "GL",  // Greenland
        "+350": "GI",  // Gibraltar
        "+351": "PT",  // Portugal
        "+352": "LU",  // Luxembourg
        "+353": "IE",  // Ireland
        "+354": "IS",  // Iceland
        "+355": "AL",  // Albania
        "+356": "MT",  // Malta
        "+357": "CY",  // Cyprus
        "+358": "FI",  // Finland
        "+359": "BG",  // Bulgaria
        "+370": "LT",  // Lithuania
        "+371": "LV",  // Latvia
        "+372": "EE",  // Estonia
        "+373": "MD",  // Moldova
        "+374": "AM",  // Armenia
        "+375": "BY",  // Belarus
        "+376": "AD",  // Andorra
        "+377": "MC",  // Monaco
        "+378": "SM",  // San Marino
        "+379": "VA",  // Vatican City
        "+380": "UA",  // Ukraine
        "+381": "RS",  // Serbia
        "+382": "ME",  // Montenegro
        "+383": "XK",  // Kosovo
        "+385": "HR",  // Croatia
        "+386": "SI",  // Slovenia
        "+387": "BA",  // Bosnia & Herzegovina
        "+389": "MK",  // North Macedonia
        "+420": "CZ",  // Czech Republic
        "+421": "SK",  // Slovakia
        "+423": "LI",  // Liechtenstein
        "+500": "FK",  // Falkland Islands
        "+501": "BZ",  // Belize
        "+502": "GT",  // Guatemala
        "+503": "SV",  // El Salvador
        "+504": "HN",  // Honduras
        "+505": "NI",  // Nicaragua
        "+506": "CR",  // Costa Rica
        "+507": "PA",  // Panama
        "+508": "PM",  // Saint Pierre & Miquelon
        "+509": "HT",  // Haiti
        "+590": "GP",  // Guadeloupe
        "+591": "BO",  // Bolivia
        "+592": "GY",  // Guyana
        "+593": "EC",  // Ecuador
        "+594": "GF",  // French Guiana
        "+595": "PY",  // Paraguay
        "+596": "MQ",  // Martinique
        "+597": "SR",  // Suriname
        "+598": "UY",  // Uruguay
        "+599": "CW",  // Curaçao (Netherlands)
        "+670": "TL",  // Timor-Leste
        "+672": "NF",  // Norfolk Island
        "+673": "BN",  // Brunei
        "+674": "NR",  // Nauru
        "+675": "PG",  // Papua New Guinea
        "+676": "TO",  // Tonga
        "+677": "SB",  // Solomon Islands
        "+678": "VU",  // Vanuatu
        "+679": "FJ",  // Fiji
        "+680": "PW",  // Palau
        "+681": "WF",  // Wallis & Futuna
        "+682": "CK",  // Cook Islands
        "+683": "NU",  // Niue
        "+685": "WS",  // Samoa
        "+686": "KI",  // Kiribati
        "+687": "NC",  // New Caledonia
        "+688": "TV",  // Tuvalu
        "+689": "PF",  // French Polynesia
        "+690": "TK",  // Tokelau
        "+691": "FM",  // Micronesia
        "+692": "MH"   // Marshall Islands
    ]

    
    // MARK: - Get ISO code from dial code
    static func getISOCode(from dialCode: String) -> String? {
        return dialCodeToISO[dialCode]
    }
    
    static func flag(from countryCode: String) -> String {
        let base: UInt32 = 127397
        var scalarView = String.UnicodeScalarView()

        for u in countryCode.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + u.value) {
                scalarView.append(scalar)
            }
        }

        return String(scalarView)
    }
    
    static func imageFromEmoji(flag: String, fontSize: CGFloat = 60) -> UIImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)

        (flag as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }


}
