// 金  2  5 2025 15:29
// Approaches for switching between waveforms.
// Example: Switch between Sine and Saw
// ------------------------------------------------------------
// Stage 0: Listen to the difference
// play one line at a time!
a = { SinOsc.ar(400, 0, 0.1).dup }.play;
a.release;
a = { LFSaw.ar(400, 0, 0.1).dup }.play;
a.release;
//: Using select in one synth.
~select = { | index = 0 |
	var sine, saw;
	sine = SinOsc.ar(400, 0, 0.1);
	saw = LFSaw.ar(500, 0, 0.05);
	Select.ar(index, [sine, saw]);
}.play;
//:
~select.set(\index, 1);
//:
~select.set(\index, 0);