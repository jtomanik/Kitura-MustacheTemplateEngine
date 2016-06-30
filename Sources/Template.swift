//
//  Template.swift
//  KituraMustache
//
//  Created by Jakub Tomanik on 30/06/16.
//
//

import Foundation
import Mustache

extension Template {

    /**
     Parses a template file, and returns a template.

     Eventual partial tags in the template refer to sibling template files using
     the same extension.

     // `{{>partial}}` in `/path/to/template.txt` loads `/path/to/partial.txt`:
     let template = try! Template(path: "/path/to/template.txt")

     - parameter path:     The path to the template file.
     - parameter encoding: The encoding of the template file.
     - parameter error:    If there is an error loading or parsing template and
     partials, throws an error that describes the problem.
     - returns: A new Template.
     */
    public convenience init(path: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        #if os(Linux)
            let url = NSURL(fileURLWithPath: path, isDirectory: false)
            let directoryPath = url.URLByDeletingLastPathComponent?.path ?? ""
            let templateExtension = url.pathExtension ?? ""
            let templateName = url.URLByDeletingPathExtension?.lastPathComponent ?? ""
        #else
            let nsPath = path.bridge()
            let directoryPath = nsPath.deletingLastPathComponent
            let templateExtension = nsPath.pathExtension
            let templateName = nsPath.lastPathComponent.bridge().deletingPathExtension
        #endif
        let repository = TemplateRepository(directoryPath: directoryPath, templateExtension: templateExtension, encoding: encoding)
        let templateAST = try repository.templateAST(named: templateName)
        self.init(repository: repository, templateAST: templateAST, baseContext: repository.configuration.baseContext)
    }
    
}