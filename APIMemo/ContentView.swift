//
//  ContentView.swift
//  APIMemo
//
//  Created by USER on 2024/10/12.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = NotesViewModel()
    @State private var isPresentingAddNote = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title).font(.headline)
                        Text(note.content).font(.subheadline)
                    }
                }
                .onDelete(perform: viewModel.deleteNote) // メモ削除
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddNote = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchNotes()
            }
            .sheet(isPresented: $isPresentingAddNote) {
                VStack {
                    TextField("Title", text: $newNoteTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    TextField("Content", text: $newNoteContent)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Button("Add Note") {
                        viewModel.addNote(title: newNoteTitle, content: newNoteContent)
                        isPresentingAddNote = false
                        newNoteTitle = ""
                        newNoteContent = ""
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}




#Preview {
    ContentView()
}
