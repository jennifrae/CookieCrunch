//
//  Array2D.swift
//  CookieCrunch
//
//  Created by 소프트가족 on 2016. 5. 13..
//  Copyright © 2016년 Bloc. All rights reserved.
//

struct Array2D<T> {
    let columns: Int
    let rows: Int
    private var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
