import Foundation
import SwiftUI

enum TimerPhase {
    case work
    case shortBreak
    case longBreak

    var color: Color {
        switch self {
        case .work: .red
        case .shortBreak: .green
        case .longBreak: .blue
        }
    }

    var duration: Int {
        switch self {
        case .work: 25 * 60
        case .shortBreak: 5 * 60
        case .longBreak: 15 * 60
        }
    }

    var label: String {
        switch self {
        case .work: "Work"
        case .shortBreak: "Short Break"
        case .longBreak: "Long Break"
        }
    }
}

@Observable
final class PomodoroTimer {
    var completedWorkSessions = 0
    var isRunning = false
    var phase: TimerPhase = .work
    var secondsRemaining = TimerPhase.work.duration

    private var timer: Timer?

    var displayTime: String {
        String(format: "%02d:%02d", secondsRemaining / 60, secondsRemaining % 60)
    }

    deinit {
        timer?.invalidate()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func reset() {
        pause()
        completedWorkSessions = 0
        phase = .work
        secondsRemaining = TimerPhase.work.duration
    }

    func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.tick()
            }
        }
    }

    private func advancePhase() {
        if phase == .work {
            completedWorkSessions += 1
            phase = completedWorkSessions.isMultiple(of: 4) ? .longBreak : .shortBreak
        } else {
            phase = .work
        }
        secondsRemaining = phase.duration
        NSSound.beep()
    }

    private func tick() {
        secondsRemaining -= 1
        if secondsRemaining <= 0 {
            advancePhase()
        }
    }
}
