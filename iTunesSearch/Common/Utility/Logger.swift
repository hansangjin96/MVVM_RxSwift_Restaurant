//
//  Logger.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/08.
//

import Foundation

struct Logger {
    private init() {}
    
    enum Level: String {
        case debug = "DEBUG"
        case info  = "INFO"
        case error = "ERROR"
        case fatal = "FATAL"
    }
    
    static func log(
        level: Level,
        message: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dfmt = DateFormatter()
        dfmt.dateFormat = dateFormat
        
        let filename = file.split(separator: "/").last ?? ""
        
        if let message = message {
            print("[\(filename)::\(function) (line:\(line))] \(message)")
        } else {
            print("[\(filename)::\(function) (line:\(line))] \(String(describing: message))")
        }
    }
    
    static func info(
        _ message: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }
    
    static func error(
        _ message: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }
    
    static func fatal(
        _ message: Any?,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .fatal, message: message, file: file, function: function, line: line)
    }
    
    static func debug(
        _ format: String,
        _ arguments: CVarArg...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .debug, message: String(format: format, arguments), file: file, function: function, line: line)
    }
}
