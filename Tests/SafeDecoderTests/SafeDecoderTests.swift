import XCTest
@testable import SafeDecoder

struct Data1 : Equatable {
    struct News: Decodable, Equatable {
        
        let newsId: String
        
        let dataid: String
                    
        let title: String
        
        var routeUri: String
        
        let recommendInfo: String
        
    }
    
    struct Tool: Decodable, Equatable {
        
        let title: String
                    
        let img: String
        
        var routeUri: String
    }
    
    struct Epidemic: Decodable, Equatable {
        
        let title: String
        
        let num: Int
        
        var routeUri: String
    }
    
    let epidemics: [Epidemic]
    
    let tools: [Tool]
    
    let news: News
    
    enum CodingKeys: String, CodingKey {
        case epidemics = "epidemic"
        case tools = "button"
        case news = "list"
    }
    
    enum Toolkeys: String, CodingKey {
        case list
    }
    
    
}

extension Data1 : Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.epidemics = try container.decode([Epidemic].self, forKey: .epidemics)
        let toolsContainer = try container.nestedContainer(keyedBy: Toolkeys.self, forKey: .tools)
        self.tools = try toolsContainer.decode([Tool].self, forKey: .list)
        let news = try container.decode([News].self, forKey: .news)
        self.news = news.first!
    }
}

final class SafeDecoderTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
    
    func testNormal() throws {
        let testData: [String : Any] = [
            "epidemic": [
                [
                    "title": "testNCoV",
                    "num": 1,
                    "routeUri": "test://url"
                ]
            ],
            "button": [
                "list": [
                    [
                        "title": "button",
                        "img": "",
                        "routeUri": "test://url"
                    ]
                ]
            ],
            "list": [
                [
                    "newsId": "newsId",
                    "dataid": "dataid",
                    "title": "news",
                    "routeUri": "test://url",
                    "recommendInfo": ""
                ]
            ]
        ]
        
        let model: Data1 = try SafeDecoder().decode(Data1.self, from: try encode(testData))
        let other: Data1 = Data1(epidemics: [
            .init(title: "testNCoV", num: 1, routeUri:"test://url")
        ], tools: [
            .init(title: "button", img: "", routeUri: "test://url")
        ], news: .init(newsId: "newsId", dataid: "dataid", title: "news", routeUri: "test://url", recommendInfo: ""))
        XCTAssertEqual(model, other)
    }
    
    func testOptional() throws {
        let testData: [String : Any] = [
            "epidemic": [
                [
                    "title": "testNCoV",
                ]
            ],
            "button": [
                "list": [
                    [
                        "title": "button",
                    ]
                ]
            ],
            "list": [
                [
                    "newsId": "newsId",
                    "title": "news",
                ]
            ]
        ]
        
        let model: Data1 = try SafeDecoder().decode(Data1.self, from: try encode(testData))
        let other: Data1 = Data1(epidemics: [
            .init(title: "testNCoV", num: 0, routeUri: "")
        ], tools: [
            .init(title: "button", img: "", routeUri: "")
        ], news: .init(newsId: "newsId", dataid: "", title: "news", routeUri: "", recommendInfo: "") )
        XCTAssertEqual(model, other)
    }
    
    struct CustomConfiguration: SafeConfigurationType {
        static var configuration: SafeDecoder.Configuration {
            var configuration: SafeDecoder.Configuration = .default
            configuration.register([Data1.Epidemic].self, value: [.init(title: "aaa", num: 20, routeUri: "test://url")])
            return configuration
        }
    }
    
    func testCustom() throws {
        
        let testData: [String : Any] = [
            
            "button": [
                "list": [
                    [
                        "title": "button",
                    ]
                ]
            ],
            "list": [
                [
                    "newsId": "newsId",
                    "title": "news",
                ]
            ]
        ]
        
        let model: Data1 = try SafeDecoder().decode(Data1.self, CustomConfiguration.self, from: try encode(testData))
        let other: Data1 = Data1(epidemics: [
            .init(title: "aaa", num: 20, routeUri: "test://url")
        ], tools: [
            .init(title: "button", img: "", routeUri: "")
        ], news: .init(newsId: "newsId", dataid: "", title: "news", routeUri: "", recommendInfo: "") )
        XCTAssertEqual(model, other)
    }
}


func encode(_ data: [String : Any]) throws -> Data {
    try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
}
