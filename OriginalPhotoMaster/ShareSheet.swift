//
//  ShareSheet.swift
//  OriginalPhotoMaster
//
//  Created by Yoshito Usui on 2025/06/27.
//

import SwiftUI

/// UIKit の UIActivityViewController を SwiftUI から呼び出すラッパー
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // 共有内容を動的に変えたい場合はここで更新処理を書く
    }
}
