(
b = Buffer.alloc(s, 44100 * 2.0, 1); // 8 second mono buffer

SynthDef(\recBuf,{ arg out=0, bufnum=0;
	var in;
	in = AudioIn.ar(1);
	RecordBuf.ar(in, bufnum);
}).load(s);

SynthDef(\playBuf, {| out = 0, bufnum = 0 |
	    Out.ar(out,
		        PlayBuf.ar(
			1, bufnum, BufRateScale.kr(bufnum),loop: 1, doneAction:2)
	    )
}).load(s);

SynthDef(\playEfecto, {| out = 0, bufnum = 0 |
	var sig, trate, dur;
	sig=PlayBuf.ar(
		1,
		bufnum,
		BufRateScale.kr(bufnum),
		loop: 1,
		doneAction:2);
	    trate = MouseY.kr(2,120,1);
	    dur = 1.2 / trate;
	    sig= TGrains.ar(
		2,
		Impulse.ar(trate),
		bufnum,
		(1.2 ** WhiteNoise.kr(3).round(1)),
		MouseX.kr(0,BufDur.kr(b)),
		dur,
		WhiteNoise.kr(0.6), 0.4);
	 Out.ar(out,5*sig);
}).load(s);

x = Synth(\recBuf, [\out, 0, \bufnum, b.bufnum]);
//z = Synth(\playEfecto, [\bufnum, b.bufnum])
z = Synth(\playBuf, [\bufnum, b.bufnum])
)
