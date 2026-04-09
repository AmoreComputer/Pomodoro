import SwiftUI

struct TimerView: View {
    @State private var timer = PomodoroTimer()

    var body: some View {
        VStack(spacing: 24) {
            Text(timer.phase.label)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(timer.phase.color)

            Text(timer.displayTime)
                .font(.system(size: 64, weight: .medium, design: .monospaced))
                .contentTransition(.numericText())
                .animation(.default, value: timer.secondsRemaining)

            sessionDots

            controls
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(timer.phase.color.opacity(0.07))
        .animation(.easeInOut, value: timer.phase)
    }

    private var controls: some View {
        HStack(spacing: 16) {
            Button {
                timer.isRunning ? timer.pause() : timer.start()
            } label: {
                Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                    .frame(width: 20)
            }
            .keyboardShortcut(.space, modifiers: [])

            Button {
                timer.reset()
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .frame(width: 20)
            }
            .disabled(!timer.isRunning && timer.phase == .work && timer.secondsRemaining == TimerPhase.work.duration)
            .keyboardShortcut("r")
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private var sessionDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                Image(systemName: index < timer.completedWorkSessions % 4 ? "circle.fill" : "circle")
                    .font(.caption)
                    .foregroundStyle(timer.phase.color.opacity(0.6))
            }
        }
    }
}
