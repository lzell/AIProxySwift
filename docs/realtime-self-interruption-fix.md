# Realtime Self-Interruption Fix Plan

## Goal

Prevent the OpenAI Realtime model from hearing its own speaker playback on iOS and incorrectly interrupting itself, while preserving intentional user barge-in behavior.

## Scope

- Primary implementation target: `AIProxySwift` (`wip/vpio-echo-cancellation`)
- Integration context reviewed: `/Users/kavimathur/workspace/joice` (CallKit + Realtime)
- APIs involved: iOS audio stack (VPIO + AVAudioEngine), OpenAI Realtime turn detection

## Mechanism Review

### AIProxySwift audio path (current branch)

1. `AudioController` chooses AudioToolbox VPIO on iOS speaker path (no headphones).
2. `MicrophonePCMSampleVendorAT` captures microphone via VPIO bus 1.
3. Playback is scheduled with `AudioPCMPlayer` on `AVAudioEngine`.
4. VPIO bus 0 render callback pulls from `audioEngine.manualRenderingBlock` as AEC reference.

This closes the biggest architectural gap from issue #240 and PR #264.

### Why interruption can still happen

Even with VPIO AEC working, residual echo can remain due to acoustics, device variance, AGC interactions, and startup/adaptation windows. OpenAI turn detection may treat that residual as user speech and emit `input_audio_buffer.speech_started`, which typical app code maps to playback interruption.

## Plan

1. Harden VPIO voice-processing configuration.
1. Add a client-side mic uplink echo guard in the VPIO callback path for iOS speaker mode:
   - Track assistant playback activity/level.
   - Suppress likely echo frames while assistant audio is active.
   - Re-open mic quickly on strong near-end speech (barge-in).
1. Keep behavior isolated to iOS speaker full-duplex mode to avoid regressions.
1. Validate by build/tests and document expected on-device QA scenarios.

## Risk Notes

- Over-aggressive suppression can make barge-in harder.
- Under-aggressive suppression can still allow self-interruption.
- iOS real-time audio timing varies by route/device, so thresholds must be conservative and tunable in code.

## Learning Log

- Initial finding: current branch correctly routes far-end audio through VPIO output callback, but does not guard against residual leakage in uplink.
- Initial finding: `joice` uses `.semanticVAD(eagerness: .medium)` and interrupts playback on every `input_audio_buffer.speech_started`, so any leakage becomes user-visible immediately.
- Implementation direction: add defense-in-depth in SDK rather than relying only on VPIO AEC.
- Attempted approach: add mic suppression wrapper in `AudioController.micStream()`.
- Course correction: Swift 6 sendability checks rejected forwarding `AVAudioPCMBuffer` across actor boundaries in that wrapper, so the echo guard moved into `MicrophonePCMSampleVendorAT` callback code (no cross-actor buffer forwarding).
- Implemented: explicitly force VPIO voice processing on (`kAUVoiceIOProperty_BypassVoiceProcessing = 0`) and disable AGC (`kAUVoiceIOProperty_VoiceProcessingEnableAGC = 0`) to reduce amplified leakage.
- Implemented: output callback now measures rendered output RMS and tracks an "assistant audio active" window.
- Implemented: input callback computes mic RMS and suppresses frames likely to be echo while assistant output is active, but allows barge-in after consecutive loud mic frames and keeps a short barge-in-open window.
- Implemented: speaker output bus + output callback setup are now limited to manual-rendering mode, preserving pre-existing macOS/non-manual behavior.
- Platform-safety update: iOS-only behavior changes are enforced for AGC/bypass settings and echo suppression; macOS/watchOS paths retain prior behavior unless unchanged baseline setup is required.
- Validation: `swift build` succeeds and `swift test` passes (172 tests, 0 failures).

## Execution Summary

- Changed `/Users/kavimathur/workspace/AIProxySwift/Sources/AIProxy/MicrophonePCMSampleVendorAT.swift`:
  - Added VPIO property hardening for bypass/AGC.
  - Added residual echo suppression logic in the real-time callback path (iOS only).
  - Added real-time RMS tracking helpers for output and microphone buffers.
- Changed `/Users/kavimathur/workspace/AIProxySwift/Sources/AIProxy/AudioController.swift`:
  - Start `AVAudioEngine` synchronously on non-watchOS to reduce startup race risk in iOS/macOS call paths.
- Added plan + log file:
  - `/Users/kavimathur/workspace/AIProxySwift/docs/realtime-self-interruption-fix.md`

## On-Device QA Checklist

1. iPhone speaker mode, no headphones: AI should complete full responses without self-interrupting.
1. While AI is speaking, interrupt loudly and verify barge-in still works within ~200-300ms.
1. Quiet room and noisy room checks: verify no constant false interruptions.
1. Headphones/Bluetooth route: verify no regression (existing non-speaker behavior unchanged).
1. CallKit route changes (speaker toggle, lock screen controls): verify conversation remains stable.

## References

- Issue context: <https://github.com/lzell/AIProxySwift/issues/240>
- Prior attempt (PR): <https://github.com/lzell/AIProxySwift/pull/264>
- OpenAI Realtime turn detection fields (`interrupt_response`, `create_response`): <https://github.com/openai/openai-realtime-api-beta/blob/main/README.md>
- Apple Audio Unit bus model (I/O unit fundamentals): <https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioUnitHostingGuide_iOS/AudioUnitHostingFundamentals/AudioUnitHostingFundamentals.html>
- Apple WWDC discussion of full-duplex voice processing echo cancellation: <https://developer.apple.com/videos/play/wwdc2011/413/>
