//
//  ItemRowViewModel.swift
//  My Portfolio
//
//  Created by Juan Diego Ocampo on 26/03/22.
//

import Foundation

extension ItemRowView {
    final class ViewModel: ObservableObject {
        let project: Project
        let item: Item
        
        var title: String {
            item.itemTitle
        }
        
        var iconViewLabel: String {
            if item.completed {
                return "checkmark.circle.fill"
            } else {
                return "circle"
            }
        }
        
        var iconViewColor: String? {
            if !item.completed {
                return project.projectColor
            } else {
                return nil
            }
        }
        
        var label: String {
            if item.completed {
                return "\(item.itemTitle), completed."
            } else if item.priority == 3 {
                return "\(item.itemTitle), high priority."
            } else if item.priority == 2 {
                return "\(item.itemTitle), medium priority."
            } else {
                return "\(item.itemTitle), low priority."
            }
        }
        
        var priorityViewLabel: String {
            if !item.completed {
                switch item.priority {
                case 1:
                    return "exclamationmark"
                case 2:
                    return "exclamationmark"
                case 3:
                    return "exclamationmark.3"
                default:
                    return "circle"
                }
            } else {
                return "circle"
            }
        }
        
        var priorityViewColor: String? {
            if !item.completed {
                switch item.priority {
                case 1:
                    return nil
                case 2:
                    return project.projectColor
                case 3:
                    return project.projectColor
                default:
                    return nil
                }
            } else {
                return nil
            }
        }
        
        init(project: Project, item: Item) {
            self.project = project
            self.item = item
        }
    }
}
