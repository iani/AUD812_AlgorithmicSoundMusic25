// Define a SynthDef inspired by the poem verse
(
SynthDef("busyOldFool", {
    |freq = 440, amp = 0.5, pan = 0, out = 0|

    // Create a basic saw wave
    var source = Saw.ar(freq);

    // Modulate the frequency to mimic the 'unruly' nature
    var mod = SinOsc.ar(freq * 0.5, 0, 20) * 0.5;

    // Create a more complex sound by adding a second oscillator
    var source2 = Saw.ar(freq + mod);

    // Apply some effects to simulate the sunlight's brightness
    var env = EnvGen.ar(Env.perc(0.01, 0.5), doneAction: 2);
    var filtered = BPF.ar(source + source2, freq * 2, 0.1);

    // Combine and pan the sound
    var mixed = (filtered * env * amp).dup; // .pan(pan);

    // Output the sound
    Out.ar(out, mixed);
}).add;
)
//:
Synth(\busyOldFool);