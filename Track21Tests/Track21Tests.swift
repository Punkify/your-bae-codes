//
//  Track21Tests.swift
//  Track21Tests
//
//  Created by J31065 on 4/11/2024.
//

import Testing
@testable import Track21

struct Track21Tests {

    @Test("Checks for multiplication") func example() async throws {
        #expect(4 == 2*2)
    }
    
    @Test("Checks for division") func example_test() async throws {
        #expect(1 == 2/2)
    }
    
    @Test("Checks for subtraction") func second_example_test() async throws {
        #expect(0 == 2-2)
    }
    
    @Test("Checks for addition") func third_example_test() async throws {
        #expect(4 == 2+3)
    }

}
