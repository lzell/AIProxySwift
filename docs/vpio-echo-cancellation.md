# VPIO Echo Cancellation Fix for iOS

## Problem

When using Joice on iOS with speaker output (no headphones), the AI's voice plays through the speaker, gets picked up by the microphone, and OpenAI's server-side VAD interprets it as user speech — causing the AI to interrupt itself.

## Root Cause

The AIProxy SDK uses `kAudioUnitSubType_VoiceProcessingIO` (VPIO) for mic capture on iOS without headphones. VPIO is designed to provide Acoustic Echo Cancellation (AEC), but **AEC was non-functional** because:

1. The VPIO output bus (Bus 0) was **explicitly disabled** in `MicrophonePCMSampleVendorAT.swift` (the comment explained that enabling it caused `render err: -1` without a data source)
2. Playback went through a completely separate `AVAudioEngine` that the VPIO had no visibility into

**For VPIO AEC to work, playback audio must flow through the VPIO's output bus as a reference signal.** The VPIO cannot cancel echo from audio it doesn't know about.

## Solution: AVAudioEngine Manual Rendering + VPIO I/O

Route playback through the VPIO by putting `AVAudioEngine` in **manual rendering mode**. The existing `AudioPCMPlayer` continues to schedule buffers on the playerNode as before, but the engine no longer renders to hardware. Instead, the VPIO output render callback **pulls** rendered audio from the engine and feeds it to the speaker through the VPIO. This gives the VPIO full visibility into both input and output for AEC.

This is the same pattern used by Twilio's Voice SDK for iOS echo cancellation.

### Signal Path

```
OpenAI 24kHz PCM16 --> AudioPCMPlayer --> playerNode --> AVAudioEngine (manual rendering, 44100Hz)
                                                              |
                                                              v
                                                VPIO output render callback
                                                calls engine.manualRenderingBlock
                                                              |
                                                              v
                                                      VPIO Bus 0 output
                                                (plays to speaker + AEC ref)

Hardware mic --> VPIO Bus 1 input (echo-cancelled) --> input callback --> resample --> OpenAI
```

## Changes

### `MicrophonePCMSampleVendorAT.swift`

1. **Added `audioEngine` property + updated `init`** — accepts an optional `AVAudioEngine` in manual rendering mode
2. **Enabled output bus 0** — changed the `zero` → `one_output` so the VPIO speaker bus is active (previously disabled to avoid `render err: -1`)
3. **Set stream format on output bus 0 (Input scope)** — Float32 at 44100Hz mono, matching the manual rendering engine format
4. **Registered a render callback on bus 0** — only when `audioEngine` is provided
5. **Implemented `didReceiveOutputRenderCallback`** — pulls audio from `audioEngine.manualRenderingBlock` into the VPIO's output buffer; fills silence on error or when no engine is present
6. **Added C-level `audioOutputRenderCallback`** — bridges to the instance method (same pattern as the existing input callback)

### `AudioController.swift`

1. **Enable manual rendering** — on iOS without headphones, puts `AVAudioEngine` into `.realtime` manual rendering mode at Float32/44100Hz/mono before any nodes are attached
2. **Pass `audioEngine` to VPIO vendor** — `MicrophonePCMSampleVendorAT(audioEngine: self.audioEngine)` so the render callback can pull from it
3. **Updated doc comment table** — iOS without headphones now notes "AudioToolbox + manual rendering AEC"

### `AudioPCMPlayer.swift`

No changes needed. The playerNode scheduling API works identically in manual rendering mode. The engine buffers audio internally and renders it when `manualRenderingBlock` is called from the VPIO output callback.

## Why This Works

1. `AudioPCMPlayer` schedules playback buffers on the playerNode at 24kHz
2. `AVAudioEngine` (in manual rendering mode at 44100Hz) internally upsamples and mixes
3. The VPIO output render callback pulls mixed audio via `manualRenderingBlock`
4. VPIO sends this audio to the hardware speaker **and** uses it as the AEC reference
5. VPIO subtracts the reference from the mic input on Bus 1, producing echo-cancelled audio
6. The echo-cancelled mic audio flows through the existing input callback unchanged

## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Volume bug with VPIO (documented in AudioPCMPlayer) | AudioPCMPlayer is initialized before VPIO (existing order in AudioController). In manual rendering mode, the engine doesn't drive hardware directly, so the bug may not apply. |
| `manualRenderingBlock` called on real-time thread | Apple docs confirm this is the intended usage — the block is designed for real-time contexts. |
| Format mismatch between engine output and VPIO bus | Both configured to Float32/44100Hz/mono. The engine handles 24kHz to 44100Hz upsampling internally. |
| macOS not addressed | macOS AT path unchanged (separate concern, less acute due to speaker/mic distance). Only iOS gets the manual rendering + VPIO AEC fix. |
| Headphones path unchanged | When headphones are connected, the `MicrophonePCMSampleVendorAE` (AVAudioEngine-based) path is used instead — no regression risk. |

## Testing

1. Build and run on a **physical iOS device** with speaker (no headphones)
2. Start a voice session — AI should speak full responses without self-interrupting
3. Speak over the AI to verify user interruption still works
4. Test with headphones to confirm no regression (headphones path is unchanged)
5. Test that playback volume is acceptable
