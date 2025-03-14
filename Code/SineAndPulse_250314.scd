// Fri 14 Mar 2025 13:46
// Notes for project by Iannis Gouras
// Objective:
// Create a synth with 2 audio UGens, one SinOsc and one LFPulse.
// THe LFPulse oscillator's frequency is always 1 octave lower than that of the SinOsc

//:Create and add SynthDef
SynthDef(\sinpulse, { | freq = 440, sinamp = 0.1, pulseamp = 0.1, gate = 1 |
	// Note: | ... | is the same as arg .... ;
	var env, src;
	// adsr envelope to make SynthDef compatible with playing in Pbind
	env = Env.adsr;
	src = SinOsc.ar(freq, 0, sinamp) + LFPulse.ar(freq / 2, mul: pulseamp);
	Out.ar(0, src * env.kr(2, gate));
}).add;
//:Test
a = Synth(\sinpulse);
//:Stop
a.release;
//:Release 0.01
a release: 0.01;
//:Release 5
a release: 5;
//:try different ratios of Sine and Pulse amplitudes:
{
	var synth;
	synth = Synth(\sinpulse);
	10 do: { | i |
		i = i + 1; // count starting from 1
		synth.set(\sinamp, 0.1 * i * 0.5, \pulseamp, 1.0 / i * 0.5);
		1.wait;
	};
	synth.release;
}.fork;