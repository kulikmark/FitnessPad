//
//  VideoPlayerView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 07.02.2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var videoData: Data?
    
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            if let player = player {
                FullScreenVideoPlayer(player: player)
                    .frame(maxWidth: .infinity, minHeight: 500, maxHeight: 600)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause() // Останавливаем видео при уходе с экрана
                    }
            } else {
                Text("No video selected")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding(.horizontal)
        .onAppear {
            loadVideo()
        }
    }
    
    private func loadVideo() {
        guard let videoData = videoData else { return }

        // Установите аудиосессию для воспроизведения звука
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session: \(error.localizedDescription)")
        }

        if let tempFileURL = createTemporaryVideoFile(from: videoData) {
            player = AVPlayer(url: tempFileURL)
        }
    }

    private func createTemporaryVideoFile(from videoData: Data) -> URL? {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent("tempVideo.mp4")
        
        do {
            try videoData.write(to: tempFileURL)
            return tempFileURL
        } catch {
            print("Failed to write video data to temporary file: \(error.localizedDescription)")
            return nil
        }
    }
}

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Обновление не требуется
    }
}
