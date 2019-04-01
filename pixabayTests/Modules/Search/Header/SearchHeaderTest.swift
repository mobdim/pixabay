//
//  SearchHeaderTest.swift
//  pixabay
//
//  Created by mobdim on 01/04/2019.
//  Copyright © 2019 pixabay. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import pixabay

fileprivate class MockRoot: SearchHeaderOutput {
    
}

class SearchHeaderSpec: QuickSpec {
    override func spec() {
        
        var root: MockRoot?
        var sut: SearchHeader?
        
        beforeEach {
            root = MockRoot()
            expect(root).toNot(beNil())
            sut = SearchHeader(root: root!)
            expect(sut).toNot(beNil())
        }
        describe("SearchHeader properties") {
            
            it("controller must not nil") {
                expect(sut?.controller).toNot(beNil())
                expect(sut?.controller.presenter).toNot(beNil())
            }
            
            it("current controller must not be nil") {
                expect(sut?.currentController).toNot(beNil())
            }
            
            it("currentController must be equal to controller") {
                expect(sut?.controller == sut?.currentController).to(beTrue())
            }
            
            it("presenter must not nil") {
                expect(sut?.presenter).toNot(beNil())
                expect(sut?.presenter.controller).toNot(beNil())
                expect(sut?.presenter.interactor).toNot(beNil())
            }
            
            it("interactor must not nil") {
                expect(sut?.interactor).toNot(beNil())
                expect(sut?.interactor.presenter).toNot(beNil())
            }
            
        }
    }
}
