//
//  NotesViewModel.swift
//  APIMemo
//
//  Created by USER on 2024/10/12.
//

import Foundation
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    func fetchNotes() {
        guard let url = URL(string: "http://localhost:3000/notes") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in //dataTask(with: )でデータ取得
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 { //ステータスコードが200の場合のみデータ処理
                    if let data = data {
                        do {
                            let notes = try JSONDecoder().decode([Note].self, from: data)
                            DispatchQueue.main.async {
                                self.notes = notes
                            }
                        } catch {
                            print("Error decoding data: \(error)")
                        }
                    }
                } else {
                    print("Request failed with status code: \(httpResponse.statusCode)")
                }
            }
        }.resume() //作成したタスクを実行する
    }
    
    func addNote(title: String, content: String) {
        guard let url = URL(string: "http://localhost:3000/notes") else { return }
        
        var request = URLRequest(url: url)  //URLRequestの初期化
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //Content-Typeヘッダーにapplication/jsonを指定
        
        let newNote = ["title": title, "content": content]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: newNote) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("Received data: \(responseString ?? "No data")")
            }
        }.resume()
    }
    
    func deleteNote(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = notes[index]
            guard let url = URL(string: "http://localhost:3000/notes/\(note.id)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { _, _, error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.notes.remove(at: index)
                    }
                }
            }.resume()
        }
    }
}
