//
//  SongDetailViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {
    var song: SongModel? = nil {
        didSet {
            guard let song = song else {
                return
            }
            fillView(song: song)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fillView(song: SongModel) {
        let artworkImageView = UIImageView(frame: self.view.frame)
        artworkImageView.contentMode = .scaleAspectFit
        self.view.addSubview(artworkImageView)
        artworkImageView.bounds.origin = self.view.bounds.origin
        artworkImageView.setImageFromURL(url: song.artworkUrl)
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let playing: Bool = (PlayerManager.shared.song == self.song && PlayerManager.shared.player?.isPlaying ?? false)
        let playAction = UIPreviewAction(title: (playing ? "Pause" : "Play"), style: .default) { (action, viewController) in
            if playing {
                PlayerManager.shared.pause()
            } else {
                if PlayerManager.shared.song != self.song { PlayerManager.shared.song = self.song }
                PlayerManager.shared.play()
            }
        }
        let shareAction = UIPreviewAction(title: "Share", style: .default) { (action, viewController) in
            log.debug("Action: \(action), viewcontroller: \(viewController)")
        }
        return [playAction, shareAction]
    }
}
