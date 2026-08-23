import Testing
@testable import minetimer

struct SoundSynthTests {
    @Test func keyIsShortAndAudible() {
        let s = SoundSynth.samples(for: .key(variant: 0))
        #expect(s.count == 1984)
        #expect(s.contains { abs($0) > 0.01 })
        #expect(s.allSatisfy { abs($0) <= 1 })
    }

    @Test func sessionEndNoteIsLongAndNotClipping() {
        let s = SoundSynth.samples(for: .workDone)
        #expect(s.count == 105840)
        #expect(s.allSatisfy { abs($0) <= 1 })
    }

    @Test func keyVariantsDiffer() {
        #expect(SoundSynth.samples(for: .key(variant: 0)) != SoundSynth.samples(for: .key(variant: 1)))
    }

    @Test func mixPadsShorterInput() {
        #expect(SoundSynth.mix([1, 1], [1]) == [2, 1])
    }
}
