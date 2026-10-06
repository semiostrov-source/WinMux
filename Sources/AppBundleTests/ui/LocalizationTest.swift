@testable import AppBundle
import Foundation
import XCTest

final class LocalizationTest: XCTestCase {
    private func bundle(_ language: String) throws -> Bundle {
        let path = try XCTUnwrap(Bundle.module.path(forResource: language, ofType: "lproj"))
        return try XCTUnwrap(Bundle(path: path))
    }

    func testPackagedLanguagesAndEnglishFallback() throws {
        XCTAssertEqual(L("WinMux Settings", bundle: try bundle("ru")), "Настройки WinMux")
        XCTAssertEqual(L("WinMux Settings", bundle: try bundle("en")), "WinMux Settings")
        XCTAssertEqual(L("untranslated-technical-key", bundle: try bundle("ru")), "untranslated-technical-key")
    }

    func testFormattedTextKeepsNamesAndNumbers() throws {
        let ru = try bundle("ru")
        XCTAssertEqual(LF("Workspace %d", 12, bundle: ru), "Рабочее пространство 12")
        XCTAssertEqual(LF("In use on %@", "Research 100%", bundle: ru), "Открыто на Research 100%")
        XCTAssertEqual(LF("'%@' is already used by custom binding: %@", "alt-h", "focus left", bundle: ru),
                       "Сочетание «alt-h» уже используется: focus left")
    }
}
