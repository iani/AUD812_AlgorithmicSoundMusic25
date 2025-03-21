//Fri 21 Mar 2025 15:25
//How to translate a flow diagram (graph) of a ugen configuration
//into code.
//Basic rule: Put the inputs in the parentheses following the .ar or .kr message
//sent to the UGen.
//:Example 1: SinOsc.
//Control input 1: freq. Control input 2: amp
{
	var ugen, freq, amp;
	freq = LFSaw.kr(1).range(400, 500);
	amp = LFTri.kr(2).range(0.01, 0.3);
	SinOsc.ar(freq, 0, amp);
}.play;
//:Example 2: Combining UGens into more complex graphs
{
	var ugen1, freq1, amp1;
	var ugen2, freq2, amp2;
	var src; // the sound source to send to output after treating
	freq1 = LFSaw.kr(1).range(400, 500);
	amp1 = LFTri.kr(2).range(0.01, 0.3);
	ugen1 = SinOsc.ar(freq1, 0, amp1);
	freq2 = LFSaw.kr(0.5).range(500 , 600);
	amp2 = LFTri.kr(0.2).range(0.01, 0.3);
	ugen2 = SinOsc.ar(freq2, 0, amp2);
	src = ugen1 + ugen2; // alternatively: Mix([ugen1, ugen2])
	src.dup; // dup = duplicate. Turn into stereo sound.
}.play
//:How to package parts of an UGen graph in a function,
//in order to keep it simple.  This means:
//Instead of writing many variable names, and many lines of code
//in one function, one can write small, simple functions,
//and then combine these functions in a larger function.
//Writing smaller simpler functions makes it easy to understand
//and test them.
//:Method:
//:Step 1: Test a small basic function
{
	var ugen, freq, amp;
	freq = LFSaw.kr(1).range(400, 500);
	amp = LFTri.kr(2).range(0.01, 0.3);
	SinOsc.ar(freq, 0, amp);
}.play;
//:Step 2: Store the small function and put it in the
// larger function that will play.
//:
var source1;
source1 = {
	var ugen, freq, amp;
	freq = LFSaw.kr(1).range(400, 500);
	amp = LFTri.kr(2).range(0.01, 0.3);
	SinOsc.ar(freq, 0, amp);
}; // Note: we do NOT play this function. We only store it.
// this is the Synth function that plays:
{
	source1;
}.play;
//:Step 3: Build a more complex graph containing several functions
var source1, source2;
source1 = {
	var freq, amp;
	freq = LFSaw.kr(1).range(400, 500);
	amp = LFTri.kr(2).range(0.01, 0.3);
	SinOsc.ar(freq, 0, amp);
};

source2 = {
	var freq, amp;
	freq = LFSaw.kr(0.3).range(150, 160);
	amp = LFTri.kr(7).range(0.01, 0.3);
	SinOsc.ar(freq, 0, amp);
};
// this is the Synth function that plays:
{
	(source1 + source2).dup;
}.play;
//:Step 4: Use arguments to build similar copies of synth graphs
//with different parameter values
var parsource;
parsource = { | freqfreq = 1, freqlo = 400, freqhi = 50,
	ampfreq = 2, amplo = 0.01, amphi = 0.3
	 |
	var ugen, freq, amp;
	freq = LFSaw.kr(freqfreq).range(freqlo, freqhi);
	amp = LFTri.kr(ampfreq).range(amplo, amphi);
	SinOsc.ar(freq, 0, amp);
};
{
	// use default parameters:
	// parsource.value;
	// use custom parameters:
	parsource.(0.15, 150, 900, 10, 0.01, 0.5);
}.play;
//:Step 5 Use the above example with sets of different parameter settings
var parsource;
parsource = { | freqfreq = 1, freqlo = 400, freqhi = 50,
	ampfreq = 2, amplo = 0.01, amphi = 0.3
	 |
	var ugen, freq, amp;
	freq = LFSaw.kr(freqfreq).range(freqlo, freqhi);
	amp = LFTri.kr(ampfreq).range(amplo, amphi);
	SinOsc.ar(freq, 0, amp);
};
{
	// use default parameters:
	// parsource.value;
	// use custom parameters:
	parsource.(0.15, 150, 900, 10, 0.01, 0.5)
	+
	parsource.(5, 1000, 2000, 1, 0.01, 0.5)
}.play;
//:Step 6. Introducing kr control inputs:
//Instead of this
	freq = LFSaw.kr(freqfreq).range(freqlo, freqhi);
//Write this
	freq = LFSaw.kr(\freqfreq.kr(freqfreq)).range(freqlo, freqhi);
// This creates a control input named \freqfreq, with default
// value freqfreq.