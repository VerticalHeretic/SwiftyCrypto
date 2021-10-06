//
//  CoinModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 17/07/2021.
//

import Foundation

/*
 curl -X 'GET' \
   'https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true' \
   -H 'accept: application/json'
 
 {
     "id": "iotex",
     "symbol": "iotx",
     "name": "IoTeX",
     "image": "https://assets.coingecko.com/coins/images/3334/large/iotex-logo.png?1547037941",
     "current_price": 0.01579282,
     "market_cap": 150242971,
     "market_cap_rank": 186,
     "fully_diluted_valuation": null,
     "total_volume": 12505542,
     "high_24h": 0.01674906,
     "low_24h": 0.014905,
     "price_change_24h": 0.00071433,
     "price_change_percentage_24h": 4.73738,
     "market_cap_change_24h": 7010262,
     "market_cap_change_percentage_24h": 4.89432,
     "circulating_supply": 9513154324.30788,
     "total_supply": null,
     "max_supply": null,
     "ath": 0.070901,
     "ath_change_percentage": -77.70352,
     "ath_date": "2018-06-01T08:24:46.753Z",
     "atl": 0.00108713,
     "atl_change_percentage": 1354.15392,
     "atl_date": "2020-03-13T02:29:47.597Z",
     "roi": null,
     "last_updated": "2021-07-17T10:49:48.094Z",
     "sparkline_in_7d": {
       "price": [
         0.018762426128393857,
         0.019201257641208447,
         0.019492803386772187,
         0.019475604437823864,
         0.01958483588821069,
         0.019441785819413006,
         0.01939541067052579,
         0.018929415906563992,
         0.018884077271072913,
         0.01882939688154055,
         0.018939725736549614,
         0.018497961103434726,
         0.018580458134075998,
         0.018508140581092222,
         0.01830968693335545,
         0.018314951099630217,
         0.018455740957268072,
         0.01841240421371602,
         0.018485486574643172,
         0.018370048829746615,
         0.01841455641924831,
         0.01906037293415387,
         0.018774801011517246,
         0.019066421102937894,
         0.01926892123815595,
         0.01914615272992753,
         0.019125259508896684,
         0.019446095887312748,
         0.019298704614544575,
         0.01940409523693073,
         0.01950096972290223,
         0.019324767401323672,
         0.019291586566821332,
         0.019224156586014927,
         0.019242593145247237,
         0.019222509816039908,
         0.019140637848810604,
         0.01925025311098784,
         0.019180406955394143,
         0.01933667903073218,
         0.0192966548772258,
         0.01926767728263597,
         0.019234020332069262,
         0.019312126799687745,
         0.01938698724696353,
         0.019625306918376,
         0.0194207254426406,
         0.019315294964633745,
         0.019431396609125837,
         0.01946727048399268,
         0.019693113516740995,
         0.019724708611548795,
         0.019124689112905224,
         0.01906124991919999,
         0.019022974266502915,
         0.01908496396803403,
         0.019164562218547565,
         0.01917284114128676,
         0.019017590831582516,
         0.018738614575848078,
         0.018807980962800386,
         0.018515439747386852,
         0.018672713569806605,
         0.018623983772607596,
         0.01884804320060519,
         0.018831643707932222,
         0.018736084632271943,
         0.018819534636877855,
         0.01889269895872146,
         0.018962727901979413,
         0.019062371029512724,
         0.018591788641970402,
         0.018798690377307796,
         0.018915653726545634,
         0.01905213336416776,
         0.019067476630572972,
         0.0190940014669786,
         0.01900585836131666,
         0.01848328884621796,
         0.018392031517103075,
         0.01829710019802139,
         0.018499390301853724,
         0.01855291105650774,
         0.01844510509267237,
         0.018338377414764604,
         0.018140880445010603,
         0.017964583554655897,
         0.018052868831205784,
         0.01800131014595387,
         0.018029548056968003,
         0.017940881510145067,
         0.017688612501057428,
         0.017684210647220533,
         0.017443688954034885,
         0.01739888328191523,
         0.017354243488203525,
         0.01751918182101665,
         0.017556436195957068,
         0.017469481891273664,
         0.017774901527324728,
         0.017957429929702964,
         0.017941334928519265,
         0.0180229081496009,
         0.018353251010395775,
         0.0183723857548947,
         0.018249222863254297,
         0.018162591024688618,
         0.01808376512808075,
         0.0180341248108355,
         0.017906961862085343,
         0.01800535413656201,
         0.01809749338690861,
         0.018136805718320336,
         0.018099921546259775,
         0.018159265288062783,
         0.01828100682198029,
         0.018194402758892243,
         0.018103085889198522,
         0.018132115408375702,
         0.018112487032001665,
         0.017986907486837848,
         0.017966543297488567,
         0.017994421817231425,
         0.018082127228095133,
         0.01768562775590369,
         0.017704387359682296,
         0.017694719079515805,
         0.017766749254427897,
         0.01784756136131606,
         0.017763139800652316,
         0.017587272610804984,
         0.01740411930058004,
         0.017380320050546176,
         0.017482780013125084,
         0.01762721154086939,
         0.017451960402803855,
         0.017857341716217154,
         0.017822862571852095,
         0.017674643970288985,
         0.017722132500165414,
         0.018092609811691907,
         0.01816827074896918,
         0.01809916569429484,
         0.018037214465051972,
         0.017827475676778705,
         0.018001057669820755,
         0.017534885257175017,
         0.017725255650678413,
         0.017783666658228364,
         0.017582893088194294,
         0.01781313449988092,
         0.018010009461662403,
         0.018089559999035904,
         0.01848276490546154,
         0.01870067865753299,
         0.018710939886047093,
         0.01876502646269248,
         0.018778903825951817,
         0.018634067270201286,
         0.018548329704245532,
         0.01922369595862077,
         0.01878878419797312,
         0.018628983693359948,
         0.018401672321867145,
         0.018406325700653117,
         0.018532159543567225,
         0.019156907490934415,
         0.019703663641363087
       ]
     }
   },
 
 */

// MARK: - Coin
struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparkline7d: SparklineIn7D?
    let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image, ath, atl
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparkline7d = "sparkline_in_7d"
        case currentHoldings
    }

    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparkline7d: sparkline7d, currentHoldings: amount)
    }

    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }

    var rank: Int {
        return Int(marketCapRank ?? 0)
    }

    static var testableCoin: Coin {
        return Coin(
        id: "testcoin",
        symbol: "tit",
        name: "Testcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 61408,
        marketCap: 1141731099010,
        marketCapRank: 1,
        fullyDilutedValuation: 1285385611303,
        totalVolume: 67190952980,
        high24H: 61712,
        low24H: 56220,
        priceChange24H: 3952.64,
        priceChangePercentage24H: 6.87944,
        marketCapChange24H: 72110681879,
        marketCapChangePercentage24H: 6.74171,
        circulatingSupply: 18653043,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 61712,
        athChangePercentage: -0.97589,
        athDate: "2021-03-13T20:49:26.606Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2021-03-13T23:18:10.268Z",
        sparkline7d: SparklineIn7D(price: [
            54019.26878317463,
            53718.060935791524,
            53677.12968669343,
            53848.3814432924,
            53561.593235320615,
            53456.0913723206,
            53888.97184353125,
            54796.37233913172,
            54593.507358383504,
            54582.558599307624,
            54635.7248282177,
            54772.612788430226,
            55192.54513921453,
            54878.11598538206,
            54513.95881205807,
            55013.68511841942,
            55145.89456844788,
            54718.37455337104,
            54954.0493828267,
            54910.13413954234,
            54778.58411728141,
            55027.87934987173,
            55473.0657777974,
            54997.291345118225,
            54991.81484262107,
            55395.61328972238,
            55530.513360661644,
            55344.4499292381,
            54889.00473869075,
            54844.521923521665,
            54710.03981625522,
            54135.005312343856,
            54278.51586384954,
            54255.871982023025,
            54346.240757736465,
            54405.90449526803,
            54909.51138548527,
            55169.3372715675,
            54810.85302834732,
            54696.044114623706,
            54332.39670114743,
            54815.81007775886,
            55013.53089568202,
            54856.867125138066,
            55090.76841223987,
            54524.41939124773,
            54864.068334250915,
            54462.38634298567,
            54810.6138506792,
            54763.5416402156,
            54621.36137575708,
            54513.628030530825,
            54356.00127005116,
            53755.786684715764,
            54024.540451750094,
            54385.912857981304,
            54399.67618552436,
            53991.52168768531,
            54683.32533920595,
            54449.31811384671,
            54409.102042970466,
            54370.86991701537,
            53731.669170540394,
            53645.37874343392,
            53841.45014070333,
            53078.52898275558,
            52881.63656182149,
            53010.25164880975,
            52936.11939761323,
            52937.55256563505,
            53413.673939003136,
            53395.17699522727,
            53596.70402266675,
            53456.22811013035,
            53483.547854166834,
            53574.40015717944,
            53681.336964452734,
            54101.59049997355,
            54318.29276391888,
            54511.25370785759,
            54332.08597577831,
            54577.323438764404,
            54477.276388342325,
            54289.676338302765,
            54218.42837403623,
            54802.18754896328,
            55985.49640087922,
            56756.316501699876,
            57210.138362768965,
            56805.27815017699,
            56682.3217648727,
            57043.194415417776,
            56912.77785094373,
            56786.15869001341,
            57003.56072100917,
            57166.66441986013,
            57828.511814425874,
            57727.41272216753,
            58721.7528896422,
            58167.84861375856,
            58180.50145658414,
            58115.72142404893,
            58058.65960870684,
            58105.84576135331,
            57815.47461888876,
            57555.387870015315,
            57506.06807298437,
            57474.98576430212,
            57943.629057843165,
            57864.43148371131,
            57518.884140001275,
            57500.77929481661,
            57368.69249425147,
            57544.96374659641,
            57642.48628971112,
            57610.310340523756,
            57801.707574342116,
            57764.18193058321,
            57403.375409342945,
            57669.860487076316,
            57812.96915967891,
            57504.33531773738,
            57444.43455289276,
            57671.75799990867,
            56629.776997674526,
            57009.09536225692,
            56974.39138798086,
            56874.43203673815,
            56652.77633376425,
            56530.179449555064,
            56387.95830875742,
            56992.622783818544,
            57181.09163589668,
            56908.09493826477,
            56902.91387334043,
            56924.327009138164,
            56636.44312948976,
            56649.998369848996,
            56825.95829302063,
            56860.281702323526,
            56917.55558938772,
            56927.31213741791,
            56754.810633329354,
            56433.44851800957,
            56600.74528738432,
            57453.29169375094,
            58130.78114831457,
            58070.47719600076,
            57930.49833482948,
            57787.23755822543,
            58021.66564986657,
            57899.998011485266,
            58833.861160841436,
            58789.11830069634,
            58491.11446437883,
            58493.58897378262,
            58757.30471138256,
            58554.84171574884,
            57839.05673758758,
            57992.34121354044,
            57699.960140573115,
            57771.20058181922,
            58080.643272295056,
            57831.48061892176,
            57430.1839517489,
            56969.140564644826,
            57154.57504790339,
            57336.828870254896

        ]),
        currentHoldings: 1.5)}

}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}
