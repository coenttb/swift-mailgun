//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import ServerFoundation

extension Templates.Client: TestDependencyKey {
    public static var testValue: Self {
        Self(
            create: { request in
                .init(
                    template: .init(
                        name: request.name ?? "Test Template",
                        description: request.description ?? "Test Description",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: "46565d87-68b6-4edb-8b3c-34554af4bb77",
                        version: .init(
                            tag: "tag",
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: "Version comment",
                            active: true,
                            id: "3efd2b85-0f41-4a1d-9898-05d7e7459c4a"
                        )
                    ),
                    message: "template has been stored"
                )
            },
            
            list: { request in
                .init(
                    items: [
                        .init(
                            name: "template_name",
                            description: "template description",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            createdBy: "",
                            id: "48d63154-8c8f-4104-ab14-687d01dbf296",
                            version: nil,
                            versions: nil
                        )
                    ],
                    paging: .init(
                        first: "https://api.mailgun.net/v3/domain/templates?page=first",
                        last: "https://api.mailgun.net/v3/domain/templates?page=last",
                        next: "https://api.mailgun.net/v3/domain/templates?page=next",
                        previous: nil
                    )
                )
            },
            
            get: { templateId, active in
                .init(
                    template: .init(
                        name: "template_name",
                        description: "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: "46565d87-68b6-4edb-8b3c-34554af4bb77",
                        version: .init(
                            tag: "tag",
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: "Version comment",
                            active: true,
                            id: "3efd2b85-0f41-4a1d-9898-05d7e7459c4a"
                        )
                    )
                )
            },
            
            update: { templateId, request in
                .init(
                    message: "template has been updated",
                    template: .init(
                        name: request.name ?? "template_name",
                        description: request.description ?? "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: "tag",
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: "Version comment",
                            active: true,
                            id: "3efd2b85-0f41-4a1d-9898-05d7e7459c4a"
                        )
                    )
                )
            },
            
            delete: { templateId in
                .init(
                    template: .init(
                        name: "template_name",
                        description: "Test template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId
                    ),
                    message: "template has been deleted"
                )
            },
            
            versions: { templateId, request in
                .init(
                    items: [
                        .init(
                            tag: "tag",
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: "Version comment",
                            active: true,
                            id: "3efd2b85-0f41-4a1d-9898-05d7e7459c4a"
                        )
                    ],
                    paging: .init(
                        first: "https://api.mailgun.net/v3/domain/templates/template/versions?page=first",
                        last: "https://api.mailgun.net/v3/domain/templates/template/versions?page=last",
                        next: "https://api.mailgun.net/v3/domain/templates/template/versions?page=next",
                        previous: nil
                    )
                )
            },
            
            createVersion: { templateId, request in
                .init(
                    message: "new version of the template has been stored",
                    template: .init(
                        name: "template_name",
                        description: "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: request.tag,
                            template: request.template,
                            engine: request.engine ?? "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: request.comment,
                            active: false,
                            id: "3efd2b85-0f41-4a1d-9898-05d7e7459c4a"
                        )
                    )
                )
            },
            
            getVersion: { templateId, versionId in
                .init(
                    template: .init(
                        name: "template_name",
                        description: "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: "tag",
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: "Version comment",
                            active: true,
                            id: versionId
                        )
                    )
                )
            },
            
            updateVersion: { templateId, versionId, request in
                .init(
                    message: "version has been updated",
                    template: .init(
                        name: "template_name",
                        description: "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: request.tag ?? "tag",
                            template: request.template ?? "<html>template content</html>",
                            engine: request.engine ?? "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: request.comment,
                            active: request.active ?? false,
                            id: versionId
                        )
                    )
                )
            },
            deleteVersion: { templateId, versionId in
                .init(
                    message: "version has been deleted",
                    template: .init(
                        name: "template_name",
                        description: "Test template description",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: "tag",
                            id: versionId
                        )
                    )
                )
            },
            copyVersion: { templateId, versionId, tag, comment in
                .init(
                    message: "version has been copied",
                    template: .init(
                        name: "template_name",
                        description: "This is the description of the template",
                        createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                        createdBy: "user-supplied-value",
                        id: templateId,
                        version: .init(
                            tag: tag,
                            template: "<html>template content</html>",
                            engine: "handlebars",
                            createdAt: "Sat, 12 Nov 1955 06:38:00 UTC",
                            comment: comment ?? "Version copy",
                            active: false,
                            id: "new-version-id"
                        )
                    )
                )
            }
        )
    }
}
