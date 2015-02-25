/*
Version 3 de Transgresión Digital
Trabajar con Buffers
*/

// Buffers

{Dust.ar(5)+WhiteNoise.ar(0.01)}.play

//============= Buffer
(
SynthDef(\playPV1, {| out = 0, bufnum = 0 |
	var sig, chain;
	sig= SoundIn.ar(1);
	sig = DelayC.ar(sig,2,2);
	chain = FFT(LocalBuf(2048),sig);
	chain = PV_BinShift(
		chain, MouseX.kr(0.25, 4, \exponential) );
	chain = IFFT(chain)!2;
	//    Out.ar(out, chanin);
	Out.ar(out, chain);
}).load(s);

SynthDef(\pShift, {| out = 0, bufnum = 0 |
	var sig, chain, grainSize =0.5;
	//sig = PlayBuf.ar(1, bufnum, 1,loop: 1, doneAction:2);
	sig= SoundIn.ar(1);
	sig = DelayC.ar(sig,2,2);
	sig =  PitchShift.ar(
		        sig,
		        grainSize,
		        1, // nominal pitch rate = 1
		        MouseX.kr(0,1),// pitch dispersion
		        MouseY.kr(0, grainSize));// time dispersion
	Out.ar(out, sig.dup);
}).load(s);

SynthDef(\pBinScramble, {| out = 0, bufnum = 0 |
	var in, chain;
	chain= SoundIn.ar(1);
	chain = DelayC.ar(chain,2,2);
	chain = FFT(LocalBuf(2048), chain);
	chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );
	chain = 1* IFFT(chain);
	    Out.ar(out, chain.dup);
}).load(s);


SynthDef(\localMax, {| out = 0, bufnum = 0 |
	var chain;
	    chain = SoundIn.ar(1);
	chain = DelayC.ar(chain,2,2);
	    chain = FFT(LocalBuf(2048), chain);
	    chain = PV_LocalMax(chain, MouseX.kr(0, 50));
	    Out.ar(out, 1* IFFT(chain).dup);
}).load(s);

SynthDef(\magFreeze, {| out = 0, bufnum = 0 |
	var chain;
	chain = SoundIn.ar(1);
	chain = DelayC.ar(chain,2,2);
	    chain = FFT(LocalBuf(2048), chain);
	    chain = PV_MagFreeze(chain, SinOsc.kr(1) );
	    Out.ar(out, 1 * IFFT(chain).dup);
}).load(s);

)
x = Synth(\recBuf);
k = Synth(\playPV1 );
m = Synth(\pShift);
z = Synth(\pBinScramble);

y = Synth(\localMax);
l = Synth(\magFreeze);


