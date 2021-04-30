//
//  SystemEventsHandler.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/18/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

protocol SystemEventsHandler {
    func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>)
    func sceneDidBecomeActive()
    func sceneWillResignActive()
//    func handlePushRegistration(result: Result<Data, Error>)
//    func appDidReceiveRemoteNotification(payload: NotificationPayload,
//                                         fetchCompletion: @escaping FetchCompletion)
}

struct AppSystemEventsHandler: SystemEventsHandler {
    let injected: AppInjection

    init(injected: AppInjection) {
        self.injected = injected

        installKeyboardHeightObserver()
    }
    
    private func installKeyboardHeightObserver() {
        let appState = injected.appState
        NotificationCenter.default.keyboardHeightPublisher
            .receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in },
                                                  receiveValue: { [appState] height in
            appState.system.keyboardHeight = height
        }))
    }

    func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url else { return }
        handle(url: url)
    }

    private func handle(url: URL) {
//        guard let deepLink = DeepLink(url: url) else { return }
//        deepLinksHandler.open(deepLink: deepLink)
    }

    func sceneDidBecomeActive() {
        injected.appState.system.isAppActive = true
//        injected.interactors.userPermissionsInteractor.resolveStatus(for: .pushNotifications)
    }

    func sceneWillResignActive() {
        injected.appState.system.isAppActive = false
    }
    
//    func handlePushRegistration(result: Result<Data, Error>) {
//        if let pushToken = try? result.get() {
//            pushTokenWebRepository
//                .register(devicePushToken: pushToken)
//                .sinkToResult { _ in }
//                .store(in: cancelBag)
//        }
//    }
//
//    func appDidReceiveRemoteNotification(payload: NotificationPayload,
//                                         fetchCompletion: @escaping FetchCompletion) {
//        container.interactors.countriesInteractor
//            .refreshCountriesList()
//            .sinkToResult { result in
//                fetchCompletion(result.isSuccess ? .newData : .failed)
//            }
//            .store(in: cancelBag)
//    }
}

// MARK: - Notifications

private extension NotificationCenter {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return Publishers.Merge(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.height ?? 0
    }
}
