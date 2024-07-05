//
//  NetworkLogsView.swift
//  OSTRich
//
//  Created by snow on 7/5/24.
//

import SwiftUI

struct NetworkLogView: View {
    @ObservedObject var logger = NetworkLogger.shared
    
    var body: some View {
        List(logger.logs) { log in
            NavigationLink(destination: DetailedLogView(log: log)) {
                VStack(alignment: .leading) {
                    Text("\(log.url)")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    HStack {
                        Text("Method: \(log.method)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        if let statusCode = log.statusCode {
                            Text("Status Code: \(statusCode)")
                                .font(.subheadline)
                                .foregroundStyle(statusCode >= 200 && statusCode < 300 ? .green : .red)
                        }
                    }
                }
                .padding()
                .cornerRadius(8)
                .shadow(radius: 1)
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Network Logs")
    }
}

struct DetailedLogView: View {
    let log: NetworkLog
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("URL")
                    .font(.headline)
                    .foregroundColor(.blue)
                HStack {
                    Text(log.url)
                        .font(.body)
                    Spacer()
                    CopyButton(textToCopy: log.url)
                }
                
                Divider()
                
                HStack {
                    Text("Method: \(log.method)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let statusCode = log.statusCode {
                        Text("Status Code: \(statusCode)")
                            .font(.subheadline)
                            .foregroundStyle(statusCode >= 200 && statusCode < 300 ? .green : .red)
                    }
                }
                
                Divider()
                
                if let headers = log.headers {
                    DisclosureGroup("Headers") {
                        VStack {
                            ForEach(headers.sorted(by: >), id: \.key) { key, value in
                                VStack {
                                    DisclosureGroup(key) {
                                        HStack {
                                            Text(value)
                                                .font(.subheadline)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            CopyButton(textToCopy: value)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
                
                if let body = log.getBodyDictionary() {
                    VStack {
                        DisclosureGroup("Body") {
                            HStack {
                                Text(prettyPrintJSON(body))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 8)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                CopyButton(textToCopy: prettyPrintJSON(body))
                            }
                        }
                    }
                    Divider()
                }
                
                if let response = log.response {
                    VStack {
                        DisclosureGroup("Response") {
                            HStack {
                                Text(response)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 8)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                CopyButton(textToCopy: response)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Log Details")
    }
    
    func prettyPrintJSON(_ dictionary: [String: Any]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return String(data: data, encoding: .utf8) ?? ""
    }
}

struct CopyButton: View {
    @State var didCopyText = false
    @State var textToCopy: String
    
    var body: some View {
        VStack {
            Button(action: {
                UIPasteboard.general.string = textToCopy
                withAnimation {
                    didCopyText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        didCopyText = false
                    }
                }
            }) {
                if didCopyText {
                    Image(systemName:  "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName:  "doc.on.doc")
                }
            }
            Spacer()
        }
    }
}
